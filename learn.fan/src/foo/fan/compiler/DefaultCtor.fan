//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//    9 Mar 06  Brian Frank  Creation
//   19 Sep 06  Brian Frank  Ported from Java to Fan
//

**
** DefaultCtor adds a default public constructor called make()
** if no constructor was explicitly specified.
**
class DefaultCtor : CompilerStep
{

  new make(Compiler fan.compiler)
    : super(fan.compiler)
  {
  }

  override Void run()
  {
    log.debug("DefaultCtor")
    walk(types, VisitDepth.typeDef)
  }

  override Void visitTypeDef(TypeDef t)
  {
    if (t.isMixin || t.isEnum) return

    hasCtor := t.methodDefs.any |MethodDef m->Bool| { return m.isCtor }
    if (hasCtor) return

    // ensure there isn't already a slot called make
    dup := t.slots["make"]
    if (dup != null)
    {
      if (dup.parent === t)
        err("Default constructor 'make' conflicts with slot at " + dup->location->toLocationStr, t.location)
      else
        err("Default constructor 'make' conflicts with inherited slot '$dup.qname'", t.location)
      return
    }

    addDefaultCtor(t, FConst.Public)
  }

  static MethodDef addDefaultCtor(TypeDef parent, Int flags)
  {
    loc := parent.location

    block := Block.make(loc)
    block.stmts.add(ReturnStmt.makeSynthetic(loc))

    m := MethodDef.make(loc, parent)
    m.flags = flags | FConst.Ctor | FConst.Synthetic
    m.name  = "make"
    m.ret   = parent.ns.voidType
    m.code  = block

    parent.addSlot(m)
    return m
  }

}