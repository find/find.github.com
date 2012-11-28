=================
Lua Դ���Ķ��ʼ�
=================

.. contents:: Ŀ¼

---------------

ĳ���� reddit ���濴�� LuaJIT �����Ƽ��� LuaԴ���Ķ�˳�� ��

	1. lmathlib.c, lstrlib.c: get familiar with the external C API. Don't bother with the pattern matcher though. Just the easy functions.
	2. lapi.c: Check how the API is implemented internally. Only skim this to get a feeling for the code. Cross-reference to lua.h and luaconf.h as needed.
	3. lobject.h: tagged values and object representation. skim through this first. you'll want to keep a window with this file open all the time.
	4. lstate.h: state objects. ditto.
	5. lopcodes.h: bytecode instruction format and opcode definitions. easy.
	6. lvm.c: scroll down to luaV_execute, the main interpreter loop. see how all of the instructions are implemented. skip the details for now. reread later.
	7. ldo.c: calls, stacks, exceptions, coroutines. tough read.
	8. lstring.c: string interning. cute, huh?
	9. ltable.c: hash tables and arrays. tricky code.
	10. ltm.c: metamethod handling, reread all of lvm.c now.
	11. You may want to reread lapi.c now.
	12. ldebug.c: surprise waiting for you. abstract interpretation is used to find object names for tracebacks. does bytecode verification, too.
	13. lparser.c, lcode.c: recursive descent parser, targetting a register-based VM. start from chunk() and work your way through. read the expression parser and the code generator parts last.
	14. lgc.c: incremental garbage collector. take your time.
	15. Read all the other files as you see references to them. Don't let your stack get too deep though.

�о����е������ԡ����Ͱ���˵������~

.. note::

    ����һ�䡭�� GNU Global ����������

    �ٲ�һ�䣬��ʵ��©���˵��㲽��Lua �ĵ�

lapi.c
=======

�� `lapi.c` �У�����Ҫ�ĺ�������˵�� ``index2addr`` �˰ɣ�

.. _index2addr:

**index2addr** :

.. code-block:: c

    static TValue *index2addr (lua_State *L, int idx) {
      CallInfo *ci = L->ci;
      if (idx > 0) {
        TValue *o = ci->func + idx;
        api_check(L, idx <= ci->top - (ci->func + 1), "unacceptable index");
        if (o >= L->top) return NONVALIDVALUE;
        else return o;
      }
      else if (idx > LUA_REGISTRYINDEX) {
        api_check(L, idx != 0 && -idx <= L->top - (ci->func + 1), "invalid index");
        return L->top + idx;
      }
      else if (idx == LUA_REGISTRYINDEX)
        return &G(L)->l_registry;
      else {  /* upvalues */
        idx = LUA_REGISTRYINDEX - idx;
        api_check(L, idx <= MAXUPVAL + 1, "upvalue index too large");
        if (ttislcf(ci->func))  /* light C function? */
          return NONVALIDVALUE;  /* it has no upvalues */
        else {
          CClosure *func = clCvalue(ci->func);
          return (idx <= func->nupvalues) ? &func->upvalue[idx-1] : NONVALIDVALUE;
        }
      }
    }

�������������ĺ������ǽ��������Ĺ���֮�ϵ� ���� ���� Lua �ĵ���
�ܶ�� Lua API �����������һ�� index ����������ָ��������ջ��\
��λ�ã����� ``lua_settop``, ``lua_remove``, ``lua_insert``, 
``lua_replace`` �ȵȣ������ `index2addr`_ ���������þ���ͨ��\
������ index ����ȡ����Ӧ�� TValue_ ���͵Ķ���ָ��

���� Registry ��Ӧ�ÿ��Ի��� `Lua �ĵ��϶��� Registry �Ľ���`__ ��
  
.. __: http://www.lua.org/manual/5.2/manual.html#4.5

����� `Pseudo Index`_ ���Կ����ú������߼����£�

===================================== ============================================
�� index > 0 ʱ                       �ڵ�ǰ function ��ջ�ռ��Ҷ�Ӧ�� TValue
�� LUA_REGISTRYINDEX < index <= 0 ʱ  �ڵ�ǰ function ��ջ�ռ������Ҷ�Ӧ�� TValue
�� index == LUA_REGISTRYINDEX ʱ      ���� registry
����( index < LUA_REGISTRYINDEX ʱ )  ���� upvalue
===================================== ============================================

lobject.h
==========

.. _TValue:

**TValue** :

.. code-block:: c

    typedef struct lua_TValue TValue;

    struct lua_TValue {
      TValuefields;
    };

    #define TValuefields	Value value_; int tt_

.. note::

   #define LUA_NANTRICK ֮�� TValuefields ���в�ͬ�Ķ��壬��������ԭ���㣬�˴����Ҽٶ�
   **û��ʹ�� LUA_NANTRICK**

`value_` �����ڱ������ݣ� `tt_` �����ڱ����������ͣ�
��ѡ�����������У�

.. _`��������`:

.. code-block:: c

    #define LUA_TNONE          (-1)

    #define LUA_TNIL           0 
    #define LUA_TBOOLEAN       1 
    #define LUA_TLIGHTUSERDATA 2 
    #define LUA_TNUMBER        3 
    #define LUA_TSTRING        4 
    #define LUA_TTABLE         5 
    #define LUA_TFUNCTION      6 
    #define LUA_TUSERDATA      7 
    #define LUA_TTHREAD        8 

BTW ���� function ���������������֣�

* lua function
* light C function
* C function

���� light C function �� C function ����������ǰ��ֻ��һ�� C ����ָ�룬
�����߿������Լ��� upvalue�������Թ���һ�� closure��

string �������������֣�

* short string
* long string

�����ߵ�����������ǰ�߻���� hash ֵ����֤��ͬ�Ķ��ַ���ȫ��Ψһ��
��Ϊ�˱��� `hash dos`_ �����ַ����������� hash ֵ

.. _`hash dos`: http://lua-users.org/wiki/HashDos

.. code-block:: c

    /* Variant tags for functions */
    #define LUA_TLCL	(LUA_TFUNCTION | (0 << 4))  /* Lua closure */
    #define LUA_TLCF	(LUA_TFUNCTION | (1 << 4))  /* light C function */
    #define LUA_TCCL	(LUA_TFUNCTION | (2 << 4))  /* C closure */

    /*
    ** LUA_TSTRING variants */
    #define LUA_TSHRSTR	(LUA_TSTRING | (0 << 4))  /* short strings */
    #define LUA_TLNGSTR	(LUA_TSTRING | (1 << 4))  /* long strings */

.. _Value:

**Value** :

.. code-block:: c

    union Value {
      GCObject *gc;    /* collectable objects */
      void *p;         /* light userdata */
      int b;           /* booleans */
      lua_CFunction f; /* light C functions */
      numfield         /* numbers */
    };

    typedef union GCObject GCObject;

���Կ������˰�ֵ���õ����ݣ� light userdata, boolean, light C function, number ����
������ string, table, function, userdata, thread �������� GCObject_ ָ����ʽ���棬
�Ա�������������


.. _`Pseudo Index`:

**Pseudo Index** :

.. code-block:: c

    #define LUAI_FIRSTPSEUDOIDX	(-LUAI_MAXSTACK - 1000)

    #define LUA_REGISTRYINDEX	LUAI_FIRSTPSEUDOIDX
    #define lua_upvalueindex(i)	(LUA_REGISTRYINDEX - (i))


**CommonHeader** :

.. code-block:: c

    /*
    ** Common Header for all collectable objects (in macro form, to be
    ** included in other objects)
    */
    #define CommonHeader	GCObject *next; lu_byte tt; lu_byte marked


CommonHeader �� Lua �����������յĽṹ������ GCObject_ * next ָ����һ���ɻ��ն���
������һ����������tt `������`__ ���ڱ����������ͣ��� marked �������ڱ���������յ�״̬

.. __: TValue_


lstate.h
=========

.. _GCObject:

**GCObject** :

.. code-block:: c

    union GCObject {
      GCheader gch;  /* common header */
      union TString ts;
      union Udata u;
      union Closure cl;
      struct Table h;
      struct Proto p;
      struct UpVal uv;
      struct lua_State th;  /* thread */
    };


