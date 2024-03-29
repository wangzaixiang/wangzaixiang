//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   15 Sep 05  Brian Frank  Creation
//

**
** Assembler assembles all the TypeDefs into their fcode representation.
**
class Assembler : CompilerSupport, FConst
{

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  new make(Compiler fan.compiler)
    : super(fan.compiler)
  {
  }

//////////////////////////////////////////////////////////////////////////
// Assemble
//////////////////////////////////////////////////////////////////////////

  FPod assemblePod()
  {
    fpod = FPod.make(null, fan.compiler.pod.name, null)

    fpod.name    = fan.compiler.input.podName
    fpod.version = fan.compiler.input.version
    fpod.depends = fan.compiler.input.depends
    fpod.fattrs  = assemblePodAttrs(fpod)

    fpod.ftypes = FType[,]
    types.each |TypeDef t|
    {
      fpod.ftypes.add(assembleType(t))
    }

    return fpod
  }

  private FAttr[] assemblePodAttrs(FPod fpod)
  {
    input := fan.compiler.input
    asm := AttrAsm.make(fan.compiler, fpod)

    buf := Buf.make
    buf.writeI2(4 + input.podFacets.size)
    buf.writeI2(fpod.addName("description")); buf.writeUtf(input.description.toCode)
    buf.writeI2(fpod.addName("buildHost"));   buf.writeUtf(Sys.hostName.toCode)
    buf.writeI2(fpod.addName("buildUser"));   buf.writeUtf(Sys.userName.toCode)
    buf.writeI2(fpod.addName("buildTime"));   buf.writeUtf(DateTime.now.toStr.toCode)
    input.podFacets.each |Obj val, Str key|
    {
      buf.writeI2(fpod.addName(key));
      buf.writeUtf(Buf.make.writeObj(val).flip.readAllStr)
    }
    asm.add(FConst.FacetsAttr, buf)

    return asm.attrs
  }

  private FType assembleType(TypeDef def)
  {
    t := FType.make(fpod)

    t.hollow   = false
    t.flags    = def.flags
    t.self     = typeRef(def)
    t.fbase    = (def.base == null) ? -1 : typeRef(def.base)
    t.fmixins  = def.mixins.map |CType m->Int| { typeRef(m) }
    t.ffields  = def.fieldDefs.map |FieldDef f->FField| { assembleField(t, f) }
    t.fmethods = def.methodDefs.map |MethodDef m->FMethod| { assembleMethod(t, m) }

    attrs := AttrAsm.make(fan.compiler, fpod)
    if (fan.compiler.input.mode == CompilerInputMode.str)
      attrs.sourceFile(def.location.fileUri)
    else
      attrs.sourceFile(def.location.filename)
    attrs.lineNumber(def.location.line)
    attrs.facets(def.facets)
    t.fattrs = attrs.attrs

    return t
  }

  FField assembleField(FType fparent, FieldDef def)
  {
    f := FField.make(fparent)
    f.nameIndex = name(def.name)
    f.flags     = def.flags
    f.typeRef   = typeRef(def.fieldType)

    attrs := AttrAsm.make(fan.compiler, fpod)
    attrs.lineNumber(def.location.line)
    attrs.facets(def.facets)
    f.fattrs = attrs.attrs

    return f;
  }

  FMethod assembleMethod(FType fparent, MethodDef def)
  {
    attrs := AttrAsm.make(fan.compiler, fpod)

    m := FMethod.make(fparent)

    m.nameIndex    = name(def.name)
    m.flags        = def.flags
    m.ret          = typeRef(def.ret)
    m.inheritedRet = typeRef(def.inheritedReturnType)
    m.paramCount   = def.params.size
    m.localCount   = def.vars.size - def.params.size

    m.vars = def.vars.map |MethodVar v->FMethodVar|
    {
      f := FMethodVar.make(m)
      f.nameIndex = name(v.name)
      f.typeRef   = typeRef(v.ctype)
      f.flags     = v.flags
      if (v.paramDef != null)
      {
        f.defNameIndex = name(ParamDefaultAttr)
        f.def = assembleExpr(v.paramDef.def)
      }
      return f
    }

    m.code = assembleCode(def, attrs)

    attrs.lineNumber(def.location.line)
    attrs.facets(def.facets)
    m.fattrs = attrs.attrs

    return m;
  }

//////////////////////////////////////////////////////////////////////////
// Utils
//////////////////////////////////////////////////////////////////////////

  Int typeRef(CType type)
  {
    return fpod.addTypeRef(type)
  }

  Int name(Str val)
  {
    return fpod.addName(val)
  }

  private Buf? assembleCode(MethodDef def , AttrAsm attrs)
  {
    block := def.code
    if (block == null) return null

    asm := CodeAsm.make(fan.compiler, def.location, fpod, def)
    if (def.ctorChain != null) asm.expr(def.ctorChain)
    asm.block(block)

    if (asm.errCount > 0) attrs.add(ErrTableAttr, asm.finishErrTable)
    if (asm.lineCount > 0) attrs.add(LineNumbersAttr, asm.finishLines)

    return asm.finishCode
  }

  private Buf? assembleExpr(Expr? expr)
  {
    if (expr == null) return null
    asm := CodeAsm.make(fan.compiler, expr.location, fpod, null)
    asm.expr(expr)
    return asm.finishCode
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  FPod? fpod
}