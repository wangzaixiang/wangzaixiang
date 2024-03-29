//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   16 Apr 06  Brian Frank  Creation
//

**
** Token is the enum for all the token types.
**
enum Token
{

//////////////////////////////////////////////////////////////////////////
// Enum
//////////////////////////////////////////////////////////////////////////

  // identifer/literals
  identifier      ("identifier"),
  strLiteral      ("Str literal"),
  intLiteral      ("Int literal"),
  floatLiteral    ("Float literal"),
  decimalLiteral  ("Decimal literal"),
  durationLiteral ("Duration literal"),
  uriLiteral      ("Uri literal"),
  dsl             ("DSL"),

  // operators
  dot("."),
  semicolon     (";"),
  comma         (","),
  colon         (":"),
  doubleColon   ("::"),
  plus          ("+"),
  minus         ("-"),
  star          ("*"),
  slash         ("/"),
  percent       ("%"),
  pound         ("#"),
  increment     ("++"),
  decrement     ("--"),
  bang          ("!"),
  question      ("?"),
  tilde         ("~"),
  pipe          ("|"),
  amp           ("&"),
  caret         ("^"),
  at            ("@"),
  doublePipe    ("||"),
  doubleAmp     ("&&"),
  same          ("==="),
  notSame       ("!=="),
  eq            ("=="),
  notEq         ("!="),
  cmp           ("<=>"),
  lt            ("<"),
  ltEq          ("<="),
  gt            (">"),
  gtEq          (">="),
  lshift        ("<<"),
  rshift        (">>"),
  lbrace        ("{"),
  rbrace        ("}"),
  lparen        ("("),
  rparen        (")"),
  lbracket      ("["),
  rbracket      ("]"),
  dotDot        (".."),
  dotDotLt      ("..<"),
  defAssign     (":="),
  assign        ("="),
  assignPlus    ("+="),
  assignMinus   ("-="),
  assignStar    ("*="),
  assignSlash   ("/="),
  assignPercent ("%="),
  assignAmp     ("&="),
  assignPipe    ("|="),
  assignCaret   ("^="),
  assignLshift  ("<<="),
  assignRshift  (">>="),
  arrow         ("->"),
  elvis         ("?:"),
  safeDot       ("?."),
  safeArrow     ("?->"),
  docComment    ("**"),
  dollar        ("\$"),

  // keywords
  abstractKeyword,
  asKeyword,
  assertKeyword,
  breakKeyword,
  caseKeyword,
  catchKeyword,
  classKeyword,
  constKeyword,
  continueKeyword,
  defaultKeyword,
  doKeyword,
  elseKeyword,
  enumKeyword,
  falseKeyword,
  finalKeyword,
  finallyKeyword,
  forKeyword,
  foreachKeyword,
  ifKeyword,
  internalKeyword,
  isKeyword,
  isnotKeyword,
  itKeyword,
  mixinKeyword,
  nativeKeyword,
  newKeyword,
  nullKeyword,
  onceKeyword,
  overrideKeyword,
  privateKeyword,
  protectedKeyword,
  publicKeyword,
  readonlyKeyword,
  returnKeyword,
  staticKeyword,
  superKeyword,
  switchKeyword,
  thisKeyword,
  throwKeyword,
  trueKeyword,
  tryKeyword,
  usingKeyword,
  virtualKeyword,
  volatileKeyword,
  voidKeyword,
  whileKeyword,

  // misc
  eof("eof");

  // potential keywords:
  //   async, checked, contract, decimal, duck, def, isnot,
  //   namespace, once, unchecked, unless, when,  var, with

//////////////////////////////////////////////////////////////////////////
// Constructor
//////////////////////////////////////////////////////////////////////////

  **
  ** Construct with symbol str, or null symbol for keyword.
  **
  private new make(Str? symbol := null)
  {
    if (symbol == null)
    {
      if (!name.endsWith("Keyword")) throw Err.make(name)
      this.symbol   = name[0..-8]
      this.keyword  = true
      this.isAssign = false
    }
    else
    {
      this.symbol   = symbol
      this.keyword  = false
      this.isAssign = name.startsWith("assign") ||
                      name == "increment" ||
                      name == "decrement"
    }
  }

//////////////////////////////////////////////////////////////////////////
// Methods
//////////////////////////////////////////////////////////////////////////

  **
  ** Get this Token as a ExprId or throw Err.
  **
  ExprId toExprId()
  {
    switch (this)
    {
      // unary
      case bang:         return ExprId.boolNot

      // binary
      case assign:       return ExprId.assign
      case doubleAmp:    return ExprId.boolAnd
      case doublePipe:   return ExprId.boolOr
      case same:         return ExprId.same
      case notSame:      return ExprId.notSame
      case elvis:        return ExprId.elvis

      // default
      default: throw Err.make(toStr)
    }
  }

  **
  ** Map an operator token to it's shortcut operator enum.
  ** Degree is 1 for unary and 2 for binary.
  **
  ShortcutOp toShortcutOp(Int degree)
  {
    switch (this)
    {
      case plus:           return ShortcutOp.plus      // a + b
      case minus:          return degree == 1 ? ShortcutOp.negate : ShortcutOp.minus  // -a; a - b
      case star:           return ShortcutOp.mult      // a * b
      case slash:          return ShortcutOp.div       // a / b
      case percent:        return ShortcutOp.mod       // a % b
      case lshift:         return ShortcutOp.lshift    // a << b
      case rshift:         return ShortcutOp.rshift    // a >> b
      case amp:            return ShortcutOp.and       // a & b
      case pipe:           return ShortcutOp.or        // a | b
      case caret:          return ShortcutOp.xor       // a ^ b
      case tilde:          return ShortcutOp.inverse   // ~a
      case increment:      return ShortcutOp.increment // ++a, a++
      case decrement:      return ShortcutOp.decrement // --a, a--
      case eq:             return ShortcutOp.eq        // a == b
      case notEq:          return ShortcutOp.eq        // a != b
      case cmp:            return ShortcutOp.cmp       // a <=> b
      case gt:             return ShortcutOp.cmp       // a > b
      case gtEq:           return ShortcutOp.cmp       // a >= b
      case lt:             return ShortcutOp.cmp       // a < b
      case ltEq:           return ShortcutOp.cmp       // a <= b
      case assignPlus:     return ShortcutOp.plus      // a += b
      case assignMinus:    return ShortcutOp.minus     // a -= b
      case assignStar:     return ShortcutOp.mult      // a *= b
      case assignSlash:    return ShortcutOp.div       // a /= b
      case assignPercent:  return ShortcutOp.mod       // a %= b
      case assignAmp:      return ShortcutOp.and       // a &= b
      case assignPipe:     return ShortcutOp.or        // a |= b
      case assignCaret:    return ShortcutOp.xor       // a ^= b
      case assignLshift:   return ShortcutOp.lshift    // a <<= b
      case assignRshift:   return ShortcutOp.rshift    // a >>= b
      default: throw Err.make(toStr)
    }
  }

  **
  ** Is one of: public, protected, internal, private
  **
  Bool isProtectionKeyword()
  {
    return this === publicKeyword || this === protectedKeyword ||
           this === internalKeyword || this === privateKeyword
  }

  override Str toStr() { return symbol }

//////////////////////////////////////////////////////////////////////////
// Keyword Lookup
//////////////////////////////////////////////////////////////////////////

  **
  ** Get a map of the keywords
  **
  const static Str:Token keywords
  static
  {
    map := Str:Token[:]
    values.each |Token t|
    {
      if (t.keyword) map[t.symbol] = t
    }
    keywords = map
  }

//////////////////////////////////////////////////////////////////////////
// Test
//////////////////////////////////////////////////////////////////////////

  static Void main()
  {
    values.each |Token t|
    {
      echo(t.name + "  '" + t.symbol + "'")
    }

    echo(keywords)
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  ** Get string used to display token to user in error messages
  const Str symbol

  ** Is this a keyword token such as "null"
  const Bool keyword

  ** Is this an assignment token such as "=", etc "+=", etc
  const Bool isAssign

}