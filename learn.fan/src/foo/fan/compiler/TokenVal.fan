//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   16 Apr 06  Brian Frank  Creation
//

**
** TokenVal stores an instance of a Token at a specific Location.
**
class TokenVal : Location
{

  new make(Token kind, Obj? val := null)
    : super.makeUninit()
  {
    this.kind = kind
    this.val  = val
  }

  override Int hash()
  {
    return kind.hash
  }

  override Bool equals(Obj? obj)
  {
    that := obj as TokenVal
    if (that == null) return false
    return (kind === that.kind) && (val == that.val)
  }

  override Str toStr()
  {
    if (kind === Token.identifier) return val.toStr
    return kind.symbol
  }

  **
  ** Return if this token is a left opening paren,
  ** but only if on the same line:
  **
  ** Ok:
  **   call(...)
  **
  ** Not ok:
  **   call
  **     (...)
  **
  Bool isCallOpenParen()
  {
    return kind === Token.lparen && !newline
  }

  **
  ** Return if this token is a left opening bracket,
  ** but only if on the same line:
  **
  ** Ok:
  **   expr[...]
  **
  ** Not ok:
  **   expr
  **     [...]
  **
  Bool isIndexOpenBracket()
  {
    return kind === Token.lbracket && !newline
  }

  Token kind      // enum for Token type
  Obj? val        // Str, Int, Float, Duration, or Str[]
  Bool newline    // have we processed one or more newlines since the last token
  Bool whitespace // was this token preceeded by whitespace
}

**
** Extra information for DSL tokens.
**
class TokenValDsl : TokenVal
{
  new make(Token kind, Str src, Int tabs, Int spaces)
    : super.make(kind, src)
  {
    leadingTabs = tabs
    leadingSpaces = spaces
  }

  Int leadingTabs     // see DslExpr
  Int leadingSpaces   // see DslExpr
}