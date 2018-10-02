/*
 * {{PackageName}}: {{Subtitle}}
 */

#include "src/compiled.h"          /* GAP headers */


Obj FuncTestCommand(Obj self)
{
    return INTOBJ_INT(42);
}

Obj FuncTestCommandWithParams(Obj self, Obj param, Obj param2)
{
    /* simply return the first parameter */
    return param;
}

// Table of functions to export
static StructGVarFunc GVarFuncs [] = {
    GVAR_FUNC(TestCommand, 0, ""),
    GVAR_FUNC(TestCommandWithParams, 2, "param, param2"),

    { 0 } /* Finish with an empty entry */
};

/******************************************************************************
**
*F  InitKernel( <module> ) . . . . . . . . .  initialise kernel data structures
*/
static Int InitKernel( StructInitInfo *module )
{
    /* init filters and functions */
    InitHdlrFuncsFromTable( GVarFuncs );

    /* return success */
    return 0;
}

/******************************************************************************
**
*F  InitLibrary( <module> ) . . . . . . . .  initialise library data structures
*/
static Int InitLibrary( StructInitInfo *module )
{
    /* init filters and functions */
    InitGVarFuncsFromTable( GVarFuncs );

    /* return success */
    return 0;
}

/******************************************************************************
**
*F  Init__Dynamic() . . . . . . . . . . . . . . . . . . table of init functions
*/
static StructInitInfo module = {
    .type = MODULE_DYNAMIC,
    .name = "{{PackageName}}",
    .initKernel = InitKernel,
    .initLibrary = InitLibrary,
};

StructInitInfo *Init__Dynamic( void )
{
    return &module;
}
