//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   24 Oct 08  Auto-generated by /adm/genfcode.rb
//

**
** FConst provides all the fcode constants
**
mixin FConst
{

//////////////////////////////////////////////////////////////////////////
// Stuff
//////////////////////////////////////////////////////////////////////////

  const static Int FCodeMagic    := 0x0FC0DE05
  const static Int FCodeVersion  := 0x01000034
  const static Int TypeDbMagic   := 0x0FC0DEDB
  const static Int TypeDbVersion := 0x01000018

//////////////////////////////////////////////////////////////////////////
// Flags
//////////////////////////////////////////////////////////////////////////

  const static Int Abstract   := 0x00000001
  const static Int Const      := 0x00000002
  const static Int Ctor       := 0x00000004
  const static Int Enum       := 0x00000008
  const static Int Final      := 0x00000010
  const static Int Getter     := 0x00000020
  const static Int Internal   := 0x00000040
  const static Int Mixin      := 0x00000080
  const static Int Native     := 0x00000100
  const static Int Override   := 0x00000200
  const static Int Private    := 0x00000400
  const static Int Protected  := 0x00000800
  const static Int Public     := 0x00001000
  const static Int Setter     := 0x00002000
  const static Int Static     := 0x00004000
  const static Int Storage    := 0x00008000
  const static Int Synthetic  := 0x00010000
  const static Int Virtual    := 0x00020000
  const static Int FlagsMask  := 0x0003ffff

//////////////////////////////////////////////////////////////////////////
// MethodVarFlags
//////////////////////////////////////////////////////////////////////////

  const static Int Param := 0x0001  // parameter or local variable

//////////////////////////////////////////////////////////////////////////
// Attributes
//////////////////////////////////////////////////////////////////////////

  const static Str ErrTableAttr     := "ErrTable"
  const static Str FacetsAttr       := "Facets"
  const static Str LineNumberAttr   := "LineNumber"
  const static Str LineNumbersAttr  := "LineNumbers"
  const static Str SourceFileAttr   := "SourceFile"
  const static Str ParamDefaultAttr := "ParamDefault"

}
