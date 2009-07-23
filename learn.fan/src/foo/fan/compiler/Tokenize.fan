//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   5 Jun 06  Brian Frank  Creation
//

**
** Tokenize is responsible for parsing all the source files into a
** a list of tokens.  Each source file is mapped to a CompilationUnit
** and stored in the PodDef.units field:
**   Compiler.srcFiles -> Compiler.pod.units
**
class Tokenize : CompilerStep
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
// Run
//////////////////////////////////////////////////////////////////////////

  **
  ** Run the step on the list of source files
  **
  override Void run()
  {
    log.debug("Tokenize")

    units := CompilationUnit[,]
    fan.compiler.srcFiles.each |File srcFile|
    {
      try
      {
        location := Location.makeFile(srcFile)
        src := srcFile.readAllStr
        units.add(tokenize(location, src))
      }
      catch (CompilerErr err)
      {
        throw err
      }
      catch (Err e)
      {
        if (srcFile.exists)
          throw err("Cannot read source file: $e", Location.makeFile(srcFile))
        else
          throw err("Source file not found", Location.makeFile(srcFile))
      }
    }
    fan.compiler.pod.units = units
  }

  **
  ** Run the step on the specified source string
  **
  Void runSource(Location location, Str src)
  {
    log.debug("Tokenize")
    unit := tokenize(location, src)
    fan.compiler.pod.units = [unit]
  }

  **
  ** Tokenize the source into a CompilationUnit
  **
  CompilationUnit tokenize(Location location, Str src)
  {
    unit := CompilationUnit.make(location, fan.compiler.pod)
    tokenizer := Tokenizer.make(fan.compiler, location, src, fan.compiler.input.includeDoc)
    unit.tokens = tokenizer.tokenize
    return unit
  }

}