//
// Copyright (c) 2009, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   15 May 09  Brian Frank  Creation
//

**
** StrDslPlugin is used to create a raw Str literal.
**
@compilerDsl="sys::Str"
class StrDslPlugin : DslPlugin
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
  ** Find a DSL plugin for the given anchor type.  If there
  ** is a problem then log an error and return null.
  **
  override Expr compile(DslExpr dsl)
  {
    LiteralExpr.makeFor(dsl.location, ns, normalizeSrc(dsl))
  }

}