//
// Copyright (c) 2009, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   15 May 09  Brian Frank  Creation
//

**
** DslPlugin is the base class for Domain Specific Language
** plugins used to compile embedded DSLs.  Subclasses are registered
** on the anchor type's qname with the "compilerDsl" facet and must
** declare a constructor with a Compiler arg.
**
abstract class DslPlugin : CompilerSupport
{

//////////////////////////////////////////////////////////////////////////
// Factory
//////////////////////////////////////////////////////////////////////////

  **
  ** Find a DSL plugin for the given anchor type.  If there
  ** is a problem then log an error and return null.
  **
  static DslPlugin? find(CompilerSupport c, Location loc, CType anchorType)
  {
    qname := anchorType.qname
    t := findByFacet("compilerDsl", qname)

    if (t.size > 1)
    {
      c.err("Multiple DSL plugins registered for '$qname': $t", loc)
      return null
    }

    if (t.size == 0)
    {
      c.err("No DSL plugin is registered for '$qname'", loc)
      return null
    }

    try
    {
      return t.first.make([c.compiler])
    }
    catch (Err e)
    {
      e.trace
      c.errReport(CompilerErr("Cannot construct DSL plugin '$t.first'", loc, e))
      return null
    }
  }

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
  ** Compile DSL source into its Fan equivalent expression.
  ** Log and throw fan.compiler error if there is a problem.
  **
  abstract Expr compile(DslExpr dsl)

//////////////////////////////////////////////////////////////////////////
// Utils
//////////////////////////////////////////////////////////////////////////

  **
  ** Normalize the DSL source using Fan's multi-line whitespace
  ** rules where no non-whitespace chars may be appear to the left
  ** of the opening "<|" token.  If source is formatted incorrectly
  ** then log and throw error.
  **
  Str normalizeSrc(DslExpr dsl)
  {
    // split the source lines, if single line just return it
    lines := dsl.src.splitLines
    if (lines.size == 1) return dsl.src

    // walk each line and normalize it
    s := StrBuf()
    s.add(lines[0])
    for (i:=1; i<lines.size; ++i)
    {
      s.addChar('\n')
      line := lines[i]

      // iterate thru each character until we've consumed
      // matching number of leading tabs and spaces
      numTabs := dsl.leadingTabs
      numSpaces := dsl.leadingSpaces
      j := 0
      for (; j<line.size; ++j)
      {
        ch := line[j]

        // consume leading tab or space
        if (ch == '\t' || ch == ' ')
        {
          if (ch == '\t') --numTabs; else --numSpaces
          if (numTabs == 0 && numSpaces == 0) break
          continue
        }

        // if we made here, that means we have a non-whitespace
        // char which is to the left of the opening "<|" token
        loc := Location(dsl.srcLoc.file, dsl.srcLoc.line+i, j+1)
        if (dsl.leadingTabs == 0)
          throw err("Leading space in $dsl.anchorType.name DSL must be $dsl.leadingSpaces spaces", loc)
        else
          throw err("Leading space in $dsl.anchorType.name DSL must be $dsl.leadingTabs tabs and $dsl.leadingSpaces spaces", loc)
      }
      if (j < line.size) s.add(line[j+1..-1])
    }
    return s.toStr
  }

}