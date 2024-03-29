//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   15 Sep 05  Brian Frank  Creation
//   29 Aug 06  Brian Frank  Ported from Java to Fan
//

**
** CNamespace is responsible for providing a unified view pods, types,
** and slots between the entities currently being compiled and the
** entities being imported from pre-compiled pods.
**
abstract class CNamespace : CompilerSupport
{

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  **
  ** Construct with associated fan.compiler.
  **
  new make(Compiler c) : super(c) {}

//////////////////////////////////////////////////////////////////////////
// Initialization
//////////////////////////////////////////////////////////////////////////

  **
  ** Once the sub class is initialized, it must call this
  ** method to initialize our all predefined values.
  **
  protected Void init()
  {
    // sys pod
    sysPod = resolvePod("sys", null)

    // error placeholder type
    error = GenericParameterType.make(this, "Error")

    // generic parameter types
    genericParams =
    [
      "A": genericParam("A"),
      "B": genericParam("B"),
      "C": genericParam("C"),
      "D": genericParam("D"),
      "E": genericParam("E"),
      "F": genericParam("F"),
      "G": genericParam("G"),
      "H": genericParam("H"),
      "K": genericParam("K"),
      "L": genericParam("L"),
      "M": genericParam("M"),
      "R": genericParam("R"),
      "V": genericParam("V"),
    ].ro()

    // types
    objType      = sysType("Obj")
    boolType     = sysType("Bool")
    enumType     = sysType("Enum")
    intType      = sysType("Int")
    floatType    = sysType("Float")
    decimalType  = sysType("Decimal")
    strType      = sysType("Str")
    strBufType   = sysType("StrBuf")
    durationType = sysType("Duration")
    listType     = sysType("List")
    mapType      = sysType("Map")
    funcType     = sysType("Func")
    errType      = sysType("Err")
    typeType     = sysType("Type")
    slotType     = sysType("Slot")
    fieldType    = sysType("Field")
    methodType   = sysType("Method")
    rangeType    = sysType("Range")
    uriType      = sysType("Uri")
    voidType     = sysType("Void")

    // methods
    objTrap            = sysMethod(objType,    "trap")
    objWith            = sysMethod(objType,    "with")
    boolNot            = sysMethod(boolType,   "not")
    intIncrement       = sysMethod(intType,    "increment")
    intDecrement       = sysMethod(intType,    "decrement")
    intPlus            = sysMethod(intType,    "plus")
    floatPlus          = sysMethod(floatType,  "plus")
    floatMinus         = sysMethod(floatType,  "minus")
    strPlus            = sysMethod(strType,    "plus")
    strBufMake         = sysMethod(strBufType, "make")
    strBufAdd          = sysMethod(strBufType, "add")
    strBufToStr        = sysMethod(strBufType, "toStr")
    listMake           = sysMethod(listType,   "make")
    listMakeObj        = sysMethod(listType,   "makeObj")
    listAdd            = sysMethod(listType,   "add")
    listToImmutable    = sysMethod(listType,   "toImmutable")
    mapMake            = sysMethod(mapType,    "make")
    mapSet             = sysMethod(mapType,    "set")
    mapToImmutable     = sysMethod(mapType,    "toImmutable")
    enumOrdinal        = sysMethod(enumType,   "ordinal")
    funcCurry          = sysMethod(funcType,   "curry")
    rangeMakeInclusive = sysMethod(rangeType,  "makeInclusive")
    rangeMakeExclusive = sysMethod(rangeType,  "makeExclusive")
    slotFindMethod     = sysMethod(slotType,   "findMethod")
    slotFindFunc       = sysMethod(slotType,   "findFunc")
    typeField          = sysMethod(typeType,   "field")
    typeMethod         = sysMethod(typeType,   "method")
    funcToImmutable    = sysMethod(funcType,   "toImmutable")

    // mock methods
    mockFlags := FConst.Public | FConst.Virtual
    funcEnterCtor   = MockMethod(funcType, "enterCtor",   mockFlags, voidType, [objType])
    funcExitCtor    = MockMethod(funcType, "exitCtor",    mockFlags, voidType, CType[,])
    funcCheckInCtor = MockMethod(funcType, "checkInCtor", mockFlags, voidType, [objType])

    itBlockType = FuncType.makeItBlock(objType)
    itBlockType.inferredSignature = true
  }

  private CType genericParam(Str name)
  {
    t := GenericParameterType.make(this, name)
    n := t.toNullable
    typeCache[t.signature] = t
    typeCache[n.signature] = n
    return t
  }

  private CType sysType(Str name)
  {
    return sysPod.resolveType(name, true)
  }

  private CMethod sysMethod(CType t, Str name)
  {
    m := t.method(name)
    if (m == null) throw Err.make("Cannot resolve '${t.qname}.$name' method in namespace")
    return m
  }

//////////////////////////////////////////////////////////////////////////
// Resolution
//////////////////////////////////////////////////////////////////////////

  **
  ** Resolve to foreign function interface bridge.
  ** Bridges are loaded once for each fan.compiler session.
  **
  private CBridge resolveBridge(Str name, Location? loc)
  {
    // check cache
    bridge := bridgeCache[name]
    if (bridge != null) return bridge

    // resolve the name by compilerBridge facet
    t := findByFacet("compilerBridge", name)
    if (t.size > 1)
      throw CompilerErr("Multiple FFI bridges available for '$name': $t", loc)
    if (t.size == 0)
      throw CompilerErr("No FFI bridge available for '$name'", loc)

    // construct bridge instance
    try
      bridge = t.first.make([fan.compiler])
    catch (Err e)
      throw CompilerErr("Cannot construct FFI bridge '$t.first'", loc, e)

    // put into cache
    bridgeCache[name] = bridge
    return bridge
  }
  private Str:CBridge bridgeCache := Str:CBridge[:]  // keyed by pod name

  **
  ** Attempt to import the specified pod name against our
  ** dependency library.  If not found then throw CompilerErr.
  **
  CPod resolvePod(Str podName, Location? loc)
  {
    // check cache
    pod := podCache[podName]
    if (pod != null) return pod

    if (podName[0] == '[')
    {
      // we have a FFI, route to bridge
      sep := podName.index("]")
      ffi := podName[1..<sep]
      package := podName[sep+1..-1]
      pod = resolveBridge(ffi, loc).resolvePod(package, loc)
    }
    else
    {
      // let namespace resolve it
      pod = findPod(podName)
      if (pod == null)
        throw CompilerErr("Pod not found '$podName'", loc)
    }

    // stash in the cache and return
    podCache[podName] = pod
    return pod
  }
  private Str:CPod podCache := Str:CPod[:]  // keyed by pod name

  **
  ** Subclass hook to resolve a pod name to a CPod implementation.
  ** Return null if not found.
  **
  protected abstract CPod? findPod(Str podName)

  **
  ** Attempt resolve a signature against our dependency
  ** library.  If not a valid signature or it can't be
  ** resolved, then throw Err.
  **
  CType resolveType(Str sig)
  {
    // check our cache first
    t := typeCache[sig]
    if (t != null) return t

    // parse it into a CType
    t = TypeParser.resolve(this, sig)
    typeCache[sig] = t
    return t
  }
  internal Str:CType typeCache := Str:CType[:]   // keyed by signature

  **
  ** Attempt resolve a slot against our dependency
  ** library.  If can't be resolved, then throw Err.
  **
  CSlot resolveSlot(Str qname)
  {
    dot := qname.indexr(".")
    slot := resolveType(qname[0..<dot]).slot(qname[dot+1..-1])
    if (slot == null) throw Err("Cannot resolve slot: $qname")
    return slot
  }

  **
  ** Map one of the generic parameter types such as "sys::V" into a CType
  **
  CType genericParameter(Str id)
  {
    t := genericParams[id]
    if (t == null) throw UnknownTypeErr.make("sys::$id")
    return t
  }

//////////////////////////////////////////////////////////////////////////
// Dependencies
//////////////////////////////////////////////////////////////////////////

  **
  ** Map of dependencies keyed by pod name set in ResolveDepends.
  **
  [Str:Depend]? depends

//////////////////////////////////////////////////////////////////////////
// Predefined
//////////////////////////////////////////////////////////////////////////

  readonly CPod? sysPod

  // generic parameters like sys::K, sys::V
  readonly [Str:CType]? genericParams

  // place holder type used for resolve errors
  readonly CType? error

  // generic type for it block until we can infer type
  readonly FuncType? itBlockType

  readonly CType? objType
  readonly CType? boolType
  readonly CType? enumType
  readonly CType? intType
  readonly CType? floatType
  readonly CType? decimalType
  readonly CType? strType
  readonly CType? strBufType
  readonly CType? durationType
  readonly CType? listType
  readonly CType? mapType
  readonly CType? funcType
  readonly CType? errType
  readonly CType? typeType
  readonly CType? slotType
  readonly CType? fieldType
  readonly CType? methodType
  readonly CType? rangeType
  readonly CType? uriType
  readonly CType? voidType

  readonly CMethod? objTrap
  readonly CMethod? objWith
  readonly CMethod? boolNot
  readonly CMethod? intIncrement
  readonly CMethod? intDecrement
  readonly CMethod? intPlus
  readonly CMethod? floatPlus
  readonly CMethod? floatMinus
  readonly CMethod? strPlus
  readonly CMethod? strBufMake
  readonly CMethod? strBufAdd
  readonly CMethod? strBufToStr
  readonly CMethod? listMake
  readonly CMethod? listMakeObj
  readonly CMethod? listAdd
  readonly CMethod? listToImmutable
  readonly CMethod? mapMake
  readonly CMethod? mapSet
  readonly CMethod? mapToImmutable
  readonly CMethod? enumOrdinal
  readonly CMethod? funcCurry
  readonly CMethod? rangeMakeInclusive
  readonly CMethod? rangeMakeExclusive
  readonly CMethod? slotFindMethod
  readonly CMethod? slotFindFunc
  readonly CMethod? typeField
  readonly CMethod? typeMethod
  readonly CMethod? funcToImmutable
  readonly CMethod? funcEnterCtor
  readonly CMethod? funcExitCtor
  readonly CMethod? funcCheckInCtor

}