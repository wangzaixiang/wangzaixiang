//
// Copyright (c) 2008, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   17 Nov 08  Brian Frank  Creation
//

**
** CBridge is the base class for fan.compiler FFI plugins to expose
** external type systems to the Fan fan.compiler as CPods, CTypes, and
** CSlots.  Subclasses are registered for a FFI name with the
** "compilerBridge" facet and must declare a constructor with a
** Compiler arg.
**
abstract class CBridge : CompilerSupport
{

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  **
  ** Constructor with associated fan.compiler.
  **
  new make(Compiler c) : super(c) {}

//////////////////////////////////////////////////////////////////////////
// Namespace
//////////////////////////////////////////////////////////////////////////

  **
  ** Resolve the specified foreign namespace to a CPod.
  ** Throw a CompilerErr with appropriate message if name
  ** cannot be resolved.
  **
  abstract CPod resolvePod(Str name, Location? loc)

//////////////////////////////////////////////////////////////////////////
// AST
//////////////////////////////////////////////////////////////////////////

  **
  ** Coerce the target expression to the specified type.  If
  ** the expression is not type compatible run the onErr function.
  ** Default implementation provides standard Fan coercion.
  **
  virtual Expr coerce(Expr expr, CType expected, |,| onErr)
  {
    return CheckErrors.doCoerce(expr, expected, onErr)
  }

  **
  ** Resolve a construction call.  Type check the arguments
  ** and insert any conversions needed.
  **
  abstract Expr resolveConstruction(CallExpr call)

  **
  ** Resolve a construction chain call where a Fan constructor
  ** calls the super-class constructor.  Type check the arguments
  ** and insert any conversions needed.
  **
  abstract Expr resolveConstructorChain(CallExpr call)

  **
  ** Resolve a method call.  Type check the arguments
  ** and insert any conversions needed.
  **
  abstract Expr resolveCall(CallExpr call)

  **
  ** Called during Inherit step when a Fan slot overrides a FFI slot.
  ** Log and throw fan.compiler error if there is a problem.
  **
  abstract Void checkOverride(TypeDef t, CSlot base, SlotDef def)

  **
  ** Called during CheckErrors step for a type which extends
  ** a FFI class or implements any FFI mixins.
  **
  abstract Void checkType(TypeDef def)


}