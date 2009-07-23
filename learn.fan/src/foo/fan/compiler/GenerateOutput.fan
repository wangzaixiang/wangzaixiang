//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   4 Nov 06  Brian Frank  Creation
//

**
** GenerateOutput creates the appropriate CompilerOutput instance
** for Compiler.output based on the configured CompilerInput.output.
**
class GenerateOutput : CompilerStep
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
    output := CompilerOutput.make
    output.mode = fan.compiler.input.output

    switch (output.mode)
    {
      case CompilerOutputMode.transientPod:
        output.transientPod = LoadPod.make(fan.compiler).load

      case CompilerOutputMode.podFile:
        output.podFile = WritePod.make(fan.compiler).write

      default:
        throw err("Unknown output type: '$output.mode'", null)
    }

    fan.compiler.output = output
  }

}