//
// Copyright (c) 2007, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   30 Aug 07  Brian Frank  Creation
//

**
** FacetDef models a facet declaration.
**
class FacetDef : Node
{

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  new make(Location location, Str name, Expr value)
    : super(location)
  {
    this.name  = name
    this.value = value
  }

//////////////////////////////////////////////////////////////////////////
// Tree
//////////////////////////////////////////////////////////////////////////

  Void walk(Visitor v)
  {
    value = value.walk(v)
  }

//////////////////////////////////////////////////////////////////////////
// Debug
//////////////////////////////////////////////////////////////////////////

  override Str toStr()
  {
    return "@$name=$value"
  }

  override Void print(AstWriter out)
  {
    out.w("@").w(name).w("=").w(value).nl
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  Str name
  Expr value

}