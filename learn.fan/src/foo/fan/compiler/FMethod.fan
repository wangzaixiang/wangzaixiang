//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   26 Dec 05  Brian Frank  Creation
//   19 Aug 06  Brian Frank  Ported from Java to Fan
//

**
** FMethod is the read/write fcode representation of sys::Method.
**
class FMethod : FSlot, CMethod
{

//////////////////////////////////////////////////////////////////////////
// Constructor
//////////////////////////////////////////////////////////////////////////

  new make(FType fparent)
    : super(fparent)
  {
  }

//////////////////////////////////////////////////////////////////////////
// Access
//////////////////////////////////////////////////////////////////////////

  FMethodVar[] fparams()
  {
    return vars.findAll |FMethodVar v->Bool| { return v.isParam }
  }

//////////////////////////////////////////////////////////////////////////
// CMethod
//////////////////////////////////////////////////////////////////////////

  override CType returnType() { return fparent.fpod.toType(ret) }
  override CParam[] params() { return fparams }

  override Str signature()
  {
    return "$returnType $name(" + params.join(",") + ")"
  }

  override once Bool isGeneric()
  {
    return calcGeneric(this)
  }

  override CType inheritedReturnType()
  {
    return fparent.fpod.toType(inheritedRet)
  }

//////////////////////////////////////////////////////////////////////////
// IO
//////////////////////////////////////////////////////////////////////////

  Void write(OutStream out)
  {
    super.writeCommon(out)
    out.writeI2(ret)
    out.writeI2(inheritedRet)
    out.write(maxStack)
    out.write(paramCount)
    out.write(localCount)
    vars.each |FMethodVar var| { var.write(out) }
    FUtil.writeBuf(out, code)
    super.writeAttrs(out)
  }

  FMethod read(InStream in)
  {
    super.readCommon(in)
    ret = in.readU2
    inheritedRet = in.readU2
    maxStack   = in.readU1
    paramCount = in.readU1
    localCount = in.readU1
    vars = FMethodVar[,];
    (paramCount+localCount).times |,| { vars.add(FMethodVar.make(this).read(in)) }
    code = FUtil.readBuf(in)
    super.readAttrs(in)
    return this
  }

  Void dump()
  {
    p := FPrinter.make(fparent.fpod)
    p.showCode = true
    p.method(this)
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  Int ret              // type qname index
  Int inheritedRet     // type qname index
  FMethodVar[]? vars   // parameters and local variables
  Int paramCount       // number of params in vars
  Int localCount       // number of locals in vars
  Buf? code            // method executable code
  Int maxStack := 16   // TODO - need to calculate in fan.compiler

}

**************************************************************************
** FMethodVar
**************************************************************************

**
** FMethodVar models one parameter or local variable in a FMethod
**
class FMethodVar : FConst, CParam
{
  new make(FMethod fmethod) { this.fmethod = fmethod }

  override Str name() { return fpod.n(nameIndex) }
  override CType paramType() { return fpod.toType(typeRef) }
  override Bool hasDefault() { return def != null }
  override Str toStr() { return "$paramType $name" }

  Bool isParam()  { return flags & FConst.Param != 0 }

  Void write(OutStream out)
  {
    out.writeI2(nameIndex)
    out.writeI2(typeRef)
    out.write(flags)

    // we currently only support the DefaultParam attr
    if (def == null) out.writeI2(0)
    else
    {
      out.writeI2(1)
      out.writeI2(defNameIndex)
      FUtil.writeBuf(out, def)
    }
  }

  FMethodVar read(InStream in)
  {
    nameIndex = in.readU2
    typeRef   = in.readU2
    flags     = in.readU1

    // we currently only support the DefaultParam attr
    in.readU2.times |,|
    {
      attrNameIndex := in.readU2
      attrBuf  := FUtil.readBuf(in)
      if (fmethod.pod.n(attrNameIndex) == ParamDefaultAttr)
      {
        defNameIndex = attrNameIndex
        def = attrBuf
      }
    }
    return this
  }

  FPod fpod() { return fmethod.fparent.fpod }

  readonly FMethod fmethod
  Int nameIndex    // name index
  Int typeRef      // typeRef index
  Int flags        // method variable flags
  Int defNameIndex // name index of DefaultParamAttr
  Buf? def         // default expression or null (only for params)

}