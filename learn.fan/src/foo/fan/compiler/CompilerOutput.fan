//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   4 Nov 06  Brian Frank  Creation
//

**
** CompilerOutput encapsulates the result of a compile.  The fan.compiler
** can output in two modes - transientPod or podFile.  In transient pod
** mode we simply compile to an in-memory pod.  In podFile mode we
** compile a pod file to the file system, but don't automatically
** load it.
**
class CompilerOutput
{

  **
  ** Mode indicates the type of this output - either a
  ** transient pod or a pod file.
  **
  CompilerOutputMode? mode

  **
  ** If transientPod mode, this is loaded pod.
  **
  Pod? transientPod

  **
  ** If podFile mode, this is the pod zip file written to disk.
  **
  File? podFile

  **
  ** If str mode, this is the output string (not used by Fan
  ** fan.compiler, but used by Javascript)
  **
  Str? str
}

**************************************************************************
** CompilerOutputMode
**************************************************************************

**
** Input source from the file system
**
enum CompilerOutputMode
{
  transientPod,
  podFile,
  str
}

