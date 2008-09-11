package sca

object BuildBlockTest {
  
  import SimpleTest._;
  
  var blocks = 0
  
  def main(args: Array[String]) {  
    var prog = SimpleTest.program;
    buildBlock(prog)
    
    prog.foreach{ x=>
      Console.println(x.block + ":\t" + x)
    }
  }
  
  def chain(program:List[Instruction]) {
    program match {
      case i1 :: i2 :: tail => 
        i1.next = i2; i2.prev = i1; chain(i2::tail);
      case _ =>
    }
  }
  
  def buildBlock(program: List[Instruction]) {
    
    program.foreach(_.block = null)
    chain(program)
    
    newBlock(program.head);    
    
  }
  
  def newBlock(first:Instruction){
    if(first.block == null || first.block.first != first) {
      blocks = blocks+1;
      new Block("block:" + blocks, first)
      next(first);
    }
    else if(first.block.first == first){
      return;
    }
  }
  
  def next(ins:Instruction) {
    ins match {
      case go: Goto => {
      	newBlock(go.target)
      	newBlock(go.next)
      }
      case cmp: IfIcmpgt => {
        newBlock(cmp.target)
        newBlock(cmp.next)
      }
      case _ => {
        if(ins.next != null) {
          ins.next.block = ins.block;
          next(ins.next);
        }
      }
    }
  }
  
  def program : List[Instruction] = {
    
    val i0 = IConst(0)
    val i1 = IStore(1)
    val i2 = IConst(0)
    val i3 = IStore(2)
    
    val i4 = ILoad(2)
    val i5 = BIPush(100)
    var i7 = IfIcmpgt()
    val i10 = ILoad(1)
    val i11 = ILoad(2)
    val i12 = IAdd()
    val i13 = IStore(1)
    val i14 = IInc(2,1)
    val i17 = Goto();
    val i20 = GetStatic("java.lang.System", "out", "java.io.PrintStream")
    val i23 = New("java.lang.StringBuilder")
    val i26 = Dup()
    val i27 = InvokeSpecial("java.lang.StringBuilder", "<init>", Nil, "void");
    val i30 = LDC("sum =")
    val i32 = InvokeVirtual("java.lang.StringBuilder", "append", List("java.lang.String"), "java.lang.StringBuilder")
    val i35 = ILoad(1)
    val i36 = InvokeVirtual("java.lang.StringBuilder", "append", List("int"), "java.lang.StringBuilder")
    val i39 = InvokeVirtual("java.lang.StringBuilder", "toString", Nil, "java.lang.String")
    val i42 = InvokeVirtual("java.io.PrintStream", "println", List("java.lang.String"),"void")
    val i45 = Return()
    
    i17.target = i4;
    i7.target = i20;

    
    /*
    var b1 = new Block().add(i0).add(i1).add(i2).add(i3)
    var b2 = new Block().add(i4).add(i5).add(i7);
    var b3 = new Block().add(i10).add(i11).add(i12).add(i13).add(i14).add(i17)
    var b4 = new Block().add(i20).add(i23).add(i26).add(i27).add(i30).add(i32).add(i35).add(i36).add(i39).add(i42).add(i45)
    */
    /*
     * b1
     * while(c2) b3
     * b4
     */

    return List( i0, i1 , i2 , i3 , i4 , i5 , i7 , i10 , i11, i12, i13 , 
      i14 , i17 , i20 , i23 , i26 , i27 , i30 , i32, i35 , i36 , i39 , i42 , i45 )
    
   }
  
}
