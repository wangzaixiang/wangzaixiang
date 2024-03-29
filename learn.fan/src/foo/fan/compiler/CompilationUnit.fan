//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   15 Sep 05  Brian Frank  Creation
//    3 Jun 06  Brian Frank  Ported from Java to Fan - Megan's b-day!
//

**
** CompilationUnit models the top level compilation unit of a source file.
**
class CompilationUnit : Node
{

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  new make(Location location, CPod pod)
    : super(location)
  {
    this.pod    = pod
    this.usings = Using[,]
    this.types  = TypeDef[,]
  }

//////////////////////////////////////////////////////////////////////////
// Debug
//////////////////////////////////////////////////////////////////////////

  override Void print(AstWriter out)
  {
    out.nl
    usings.each |Using u| { u.print(out) }
    types.each |TypeDef t| { t.print(out) }
  }

  override Str toStr()
  {
    return location.toStr
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  CPod pod                      // ctor
  TokenVal[]? tokens            // Tokenize
  Using[] usings                // ScanForUsingsAndTypes
  TypeDef[] types               // ScanForUsingsAndTypes
  [Str:CType[]]? importedTypes  // ResolveImports (includes my pod)

}