//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   15 Sep 05  Brian Frank  Creation
//   20 Aug 06  Brian Frank  Ported from Java to Fan
//

**
** AttrAsm provides support for assembling the attributes
** table for types and slots.
**
class AttrAsm : CompilerSupport
{

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  new make(Compiler fan.compiler, FPod fpod)
    : super(fan.compiler)
  {
    this.fpod = fpod;
    this.attrs = FAttr[,]
  }

//////////////////////////////////////////////////////////////////////////
// Named Adds
//////////////////////////////////////////////////////////////////////////

  Void sourceFile(Str? source)
  {
    if (source == null) return
    utf(FConst.SourceFileAttr, source)
  }

  Void lineNumber(Int? line)
  {
    if (line == null || line == 0) return
    u2(FConst.LineNumberAttr, line)
  }

  Void facets([Str:FacetDef]? facets)
  {
    if (facets == null || facets.isEmpty) return

    buf := Buf.make
    buf.writeI2(facets.size)
    facets.each |FacetDef f|
    {
      buf.writeI2(fpod.addName(f.name))
      try
      {
        buf.writeUtf(f.value.serialize)
      }
      catch (CompilerErr e)
      {
        err("Facet value is not serializable: '$f.name' ($e.message)", f.value.location)
      }
    }
    add(FConst.FacetsAttr, buf)
  }

//////////////////////////////////////////////////////////////////////////
// Generic Adds
//////////////////////////////////////////////////////////////////////////

  Void utf(Str name, Str data)
  {
    buf := Buf.make
    buf.writeUtf(data)
    add(name, buf)
  }

  Void u2(Str name, Int data)
  {
    buf := Buf.make
    buf.writeI2(data)
    add(name, buf)
  }

  Void add(Str name, Buf data)
  {
    a := FAttr.make
    a.name = fpod.addName(name)
    a.data = data
    attrs.add(a)
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  FPod fpod
  FAttr[] attrs

}