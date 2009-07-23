//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   20 Aug 06  Brian Frank  Creation
//

**
** Assemble is responsible for assembling the resolved, analyzed,
** normalized abstract syntax tree into it's fcode representation
** in memory as a FPod stored on fan.compiler.fpod.
**
class Assemble : CompilerStep
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
    log.debug("Assemble")
    fan.compiler.fpod = Assembler.make(fan.compiler).assemblePod
    bombIfErr
    if (fan.compiler.input.fcodeDump) fan.compiler.fpod.dump(log.out)
  }

}