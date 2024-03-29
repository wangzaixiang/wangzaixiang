//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   5 Jun 06  Brian Frank  Creation
//

**
** ScanForUsingsAndTypes is the first phase in a two pass parser.  Here
** we scan thru the tokens to parse using declarations and type definitions
** so that we can fully define the namespace of types.  The result of this
** step is to populate each CompilationUnit's using and types, and the
** PodDef.typeDefs map.
**
class ScanForUsingsAndTypes : CompilerStep
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
    log.debug("ScanForUsingsAndTypes")

    allTypes := Str:TypeDef[:]

    units.each |CompilationUnit unit|
    {
      UsingAndTypeScanner.make(fan.compiler, unit, allTypes).parse
    }
    bombIfErr

    fan.compiler.pod.typeDefs = allTypes
  }

}

**************************************************************************
** UsingAndTypeScanner
**************************************************************************

class UsingAndTypeScanner : CompilerSupport
{
  new make(Compiler fan.compiler, CompilationUnit unit, Str:TypeDef allTypes)
    : super(fan.compiler)
  {
    this.unit     = unit
    this.tokens   = unit.tokens
    this.pos      = 0
    this.allTypes = allTypes
    this.isSys    = fan.compiler.isSys
  }

  Void parse()
  {
    // sys is imported implicitly (unless this is sys itself)
    if (!isSys)
      unit.usings.add(Using.make(unit.location) { podName="sys" })

    // scan tokens quickly looking for keywords
    inClassHeader := false
    while (true)
    {
      tok := consume
      if (tok.kind === Token.eof) break
      switch (tok.kind)
      {
        case Token.usingKeyword:
          parseUsing(tok)
        case Token.lbrace:
          inClassHeader = false
        case Token.classKeyword:
        case Token.mixinKeyword:
        case Token.enumKeyword:
          if (!inClassHeader)
          {
            inClassHeader = true;
            parseType(tok);
          }
      }
    }
  }

  private Void parseUsing(TokenVal tok)
  {
    u := Using.make(tok)

    // using [ffi]
    u.podName = ""
    if (curt === Token.lbracket)
    {
      consume
      u.podName = "[" + consumeId + "]"
      consume(Token.rbracket)

    }

    // using [ffi] pod
    u.podName += consumeId
    while (curt === Token.dot) // allow dots in pod name
    {
      consume
      u.podName += "." + consumeId
    }

    // using [ffi] pod::type
    if (curt === Token.doubleColon)
    {
      consume
      u.typeName = consumeId
      while (curt === Token.dollar) // allow $ in type name
      {
        consume
        u.typeName += "\$"
        if (curt == Token.identifier) u.typeName += consumeId
      }

      // using [ffi] pod::type as rename
      if (curt === Token.asKeyword)
      {
        consume
        u.asName = consumeId
      }
    }

    unit.usings.add(u)
  }

  private Void parseType(TokenVal tok)
  {
    name := consumeId
    typeDef := TypeDef.make(ns, tok, unit, name)
    unit.types.add(typeDef)

    // set enum/mixin flag to use by Parser
    if (tok.kind === Token.mixinKeyword)
      typeDef.flags |= FConst.Mixin
    else if (tok.kind === Token.enumKeyword)
      typeDef.flags |= FConst.Enum

    // check for duplicate type names
    if (allTypes.containsKey(name))
      err("Duplicate type name '$name'", typeDef.location)
    else
      allTypes[name] = typeDef
  }

  private Str consumeId()
  {
    id := consume
    if (id.kind != Token.identifier)
    {
      err("Expected identifier", id)
      return ""
    }
    return (Str)id.val
  }

  private Void verify(Token expected)
  {
    if (curt !== expected)
      err("Expected '$expected.symbol', not '${tokens[pos]}'", tokens[pos]);
  }

  private TokenVal consume(Token? expected := null)
  {
    if (expected != null) verify(expected)
    return tokens[pos++]
  }

  private Token curt()
  {
    return tokens[pos].kind
  }

  private CompilationUnit unit
  private TokenVal[] tokens
  private Int pos
  private Bool isSys := false
  private Str:TypeDef allTypes

}