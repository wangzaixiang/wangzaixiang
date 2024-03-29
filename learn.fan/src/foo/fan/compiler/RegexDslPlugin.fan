//
// Copyright (c) 2009, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   15 May 09  Brian Frank  Creation
//

**
** RegexDslPlugin is used to create a Regex instance from a raw string.
**
@compilerDsl="sys::Regex"
class RegexDslPlugin : DslPlugin
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
    regexType := ns.resolveType("sys::Regex")
    fromStr := regexType.method("fromStr")
    args := [LiteralExpr.makeFor(dsl.location, ns, dsl.src)]
    return CallExpr.makeWithMethod(dsl.location, null, fromStr, args)
  }

}