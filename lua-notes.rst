=================
Lua 源码阅读笔记
=================

.. contents:: 目录

---------------

某天在 reddit 上面看到 LuaJIT 作者推荐的 Lua源码阅读顺序 ：

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

感觉很有道理，所以……就按他说的来吧~

.. note::

    唔，插一句…… GNU Global 真是神器！

    再插一句，其实他漏掉了第零步：Lua 文档

Be Prepared
===========

* 去看看 `Lua Manual`_
* 去 `Lua Wiki`_ 看看 Lua 代码的组织方式和代码风格
* 打开 `Lua Source`_ 对着看

Lua 代码风格：

::

    luaA_ - lapi.c
    luaB_ - lbaselib.c
    luaC_ - lgc.c
    luaD_ - ldo.c
    luaE_ - lstate.c
    luaF_ - lfunc.c
    luaG_ - ldebug.c
    luaH_ - ltable.c
    luaI_ - lauxlib.c
    luaK_ - lcode.c
    luaL_ - lauxlib.c/h, linit.c (public functions)
    luaM_ - lmem.c
    luaO_ - lobject.c
    luaP_ - lopcodes.c
    luaS_ - lstring.c
    luaT_ - ltm.c
    luaU_ - lundump.c
    luaV_ - lvm.c
    luaX_ - llex.c
    luaY_ - lparser.c
    luaZ_ - lzio.c
    lua_  - lapi.c/h + luaconf.h, debug.c
    luai_ - luaconf.h
    luaopen_ - luaconf.h + libraries (lbaselib.c, ldblib.c, liolib.c, lmathlib.c,
                                      loadlib.c, loslib.c, lstrlib.c, ltablib.c)

lapi.c
=======

在 `lapi.c` 中，最重要的函数可以说是 ``index2addr`` 了吧：

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

几乎所有其他的函数都是建立在它的功能之上的 —— 回忆 Lua 文档，
很多的 Lua API 函数都会接受一个 index 参数，用来指定参数在栈上\
的位置，比如 ``lua_settop``, ``lua_remove``, ``lua_insert``, 
``lua_replace`` 等等，而这个 `index2addr`_ 函数的作用就是通过\
给定的 index 参数取出对应的 TValue_ 类型的对象指针

关于 Registry 的应用可以回忆 `Lua 文档上对于 Registry 的介绍`__ 。
  
.. __: http://www.lua.org/manual/5.2/manual.html#4.5

而结合 `Pseudo Index`_ 可以看出该函数的逻辑如下：

===================================== ============================================
当 index > 0 时                       在当前 function 的栈空间找对应的 TValue
当 LUA_REGISTRYINDEX < index <= 0 时  在当前 function 的栈空间逆向找对应的 TValue
当 index == LUA_REGISTRYINDEX 时      返回 registry
否则( index < LUA_REGISTRYINDEX 时 )  查找 upvalue
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

   #define LUA_NANTRICK 之后， TValuefields 会有不同的定义，不过基本原理不便，此处暂且假定
   **没有使用 LUA_NANTRICK**

`value_` 项用于保存数据， `tt_` 项用于保存数据类型；
可选的数据类型有：

.. _`数据类型`:

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

BTW 其中 function 类型又有三种区分：

* lua function
* light C function
* C function

其中 light C function 与 C function 的区别在于前者只是一个 C 函数指针，
而后者可以有自己的 upvalue，即可以构成一个 closure。

string 类型有两种区分：

* short string
* long string

这两者的区别则在于前者会计算 hash 值，保证相同的短字符串全局唯一；
而为了避免 `hash dos`_ ，长字符串并不计算 hash 值

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

可以看出除了按值引用的数据（ light userdata, boolean, light C function, number ），
其他（ string, table, function, userdata, thread ）都是以 GCObject_ 指针形式保存，
以便用于垃圾回收


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


CommonHeader 是 Lua 用于垃圾回收的结构，其中 GCObject_ * next 指向下一个可回收对象，
构成了一个单向链表，tt `依旧是`__ 用于保存数据类型，而 marked 则是用于标记垃圾回收的状态

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

.. _CallInfo:

**CallInfo** :

.. code-block:: c

    /*
    ** information about a call
    */
    typedef struct CallInfo {
      StkId func;  /* function index in the stack */
      StkId	top;  /* top for this function */
      struct CallInfo *previous, *next;  /* dynamic call link */
      short nresults;  /* expected number of results from this function */
      lu_byte callstatus;
      ptrdiff_t extra;
      union {
        struct {  /* only for Lua functions */
          StkId base;  /* base for this function */
          const Instruction *savedpc;
        } l;
        struct {  /* only for C functions */
          int ctx;  /* context info. in case of yields */
          lua_CFunction k;  /* continuation in case of yields */
          ptrdiff_t old_errfunc;
          lu_byte old_allowhook;
          lu_byte status;
        } c;
      } u;
    } CallInfo;

    /*
    ** Bits in CallInfo status
    */
    #define CIST_LUA	(1<<0)	/* call is running a Lua function */
    #define CIST_HOOKED	(1<<1)	/* call is running a debug hook */
    #define CIST_REENTRY	(1<<2)	/* call is running on same invocation of
                                       luaV_execute of previous call */
    #define CIST_YIELDED	(1<<3)	/* call reentered after suspension */
    #define CIST_YPCALL	(1<<4)	/* call is a yieldable protected call */
    #define CIST_STAT	(1<<5)	/* call has an error status (pcall) */
    #define CIST_TAIL	(1<<6)	/* call was tail called */
    #define CIST_HOOKYIELD	(1<<7)	/* last hook called yielded */


.. _`Lua Manual`: http://www.lua.org/manual/5.2/manual.html
.. _`Lua Wiki`: http://lua-users.org/wiki/LuaSource
.. _`Lua Source`: http://www.lua.org/source/5.2/
