//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   3 Jun 06  Brian Frank  Creation
//

**
** Parse is responsible for parsing all the compilation units which
** have already been tokenized into their full abstract syntax tree
** representation in memory.  Once complete this step populates the
** Compiler.types list with the list of declared types.
**
class Parse : CompilerStep
{

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  **
  ** Constructor takes the associated Compiler
  **
  new make(Compiler fan.compiler)
    : super(fan.compiler)
  {
  }

//////////////////////////////////////////////////////////////////////////
// Methods
//////////////////////////////////////////////////////////////////////////

  **
  ** Run the step
  **
  override Void run()
  {
    log.debug("Parse")

    types := TypeDef[,]
    closures := ClosureExpr[,]

    units.each |CompilationUnit unit|
    {
      Parser.make(fan.compiler, unit, closures).parse
      types.addAll(unit.types)
    }

    bombIfErr
    fan.compiler.types = types
    fan.compiler.closures = closures
  }

}