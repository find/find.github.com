============
Lua �Ķ��ʼ�
============


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


