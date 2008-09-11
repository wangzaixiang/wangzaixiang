package sca

// then we need to know if/else and loop
object SimpleTest {

  def main(args: Array[String]) {
    eval(program)
  }
  
  private def concat(strs:List[String], seperator: String):String = {
      strs match {
        case head::Nil => return head;
        case head::tail => return head + seperator + concat(tail, seperator);
        case Nil => return "";
      }
    }

  case class Block(name:String, first:Instruction) {
    first.block = this
  }

  abstract class Instruction {
    var block: Block = null;
    var prev,next: Instruction = null;
  }
  case class IConst(operand:Int) extends Instruction;
  case class IStore(operand:Int) extends Instruction;
  case class ILoad(operand:Int) extends Instruction;
  case class BIPush(operand:Byte) extends Instruction;
  case class IfIcmpgt() extends Instruction{
    var target: Instruction = null
  }
  case class IAdd extends Instruction;
  case class IInc(pos: Int, value: Int) extends Instruction;
  case class Goto() extends Instruction {
    var target: Instruction = null
  }
  case class GetStatic(clazz: String, field: String, signature: String) extends Instruction;
  case class New(clazz:String) extends Instruction;
  case class Dup() extends Instruction;
  case class InvokeSpecial(clazz:String, method:String, argument: List[String], result:String) extends Instruction;
  case class LDC(operand:String) extends Instruction;
  case class InvokeVirtual(clazz:String, method:String, argument: List[String], result:String) extends Instruction;
  case class Return extends Instruction;
  
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

    return List( i0, i1 , i2 , i3 , i4 , i5 , i7 , i10 , i11, i12, i13 , 
      i14 , i17 , i20 , i23 , i26 , i27 , i30 , i32, i35 , i36 , i39 , i42 , i45 )
    
   }
  
  abstract class Expr;
  abstract class Statement;
  
  case class Constant(typ:String, literal:String) extends Expr;
  case class LocalVar(pos:Int) extends Expr;
  case class Add(op1:Expr, op2:Expr) extends Expr;
  case class PathExpr(op1: String, op2: String) extends Expr;
  case class NewExpr(clazz:String) extends Expr;
  case class CallExpr(obj: Expr, method:String, args:List[Expr]) extends Expr {
    override def toString = {
      var strs: List[String] = args.map(_.toString);
      obj.toString + "." + method + "(" +  concat(strs, ",") + ")";
    }
    
  }
  
  case class SetVar(pos:Int, value:Expr) extends Statement
  case class IfStmt(op1: Expr, operation:String, op2: Expr) extends Statement;
  case class GotoStmt(target:Instruction) extends Statement;
  case class InvokeStmt(obj: Expr, method: String, args: List[Expr]) extends Statement {
    override def toString = {
      var strs: List[String] = args.map(_.toString);
      obj.toString + "." + method + "(" +  concat(strs, ",") + ")";
    }    
  }
  
  def eval(prog: List[Instruction]) = {
    
    var stack = List[Expr]()
    
    prog foreach { x =>
      x match {
        case IConst(op) => stack = Constant("int", "" + op) :: stack
        case IStore(op) => 
          {
            val pop = stack.head
            println( SetVar(op, pop) )
            stack = stack.tail
          }
        case ILoad(op) => stack = LocalVar(op) :: stack;
        case BIPush(op) => stack = Constant("byte", "" + op) :: stack
        case IfIcmpgt() =>  stack match { case op2 :: op1 :: tail =>
          {
            println( IfStmt(op1, ">", op2) );
            stack = tail;
          }}
        case IInc(pos, value) => 
          {
            println( SetVar(pos, Add(LocalVar(pos), Constant("int", ""+value)) ) );
          }
        case go: Goto => println( GotoStmt(go.target) );
        case GetStatic(clazz, field, signature) =>
          {
            stack = PathExpr(clazz, field) :: stack;
          }
        case New(clazz) => stack = NewExpr(clazz) :: stack
        case Dup() => stack = stack.head :: stack
        case IAdd() => stack match {
          case op2 :: op1 :: tail => stack = Add(op1, op2) :: tail;
        }
        case InvokeSpecial(clazz, method, args, result) =>
          {
            stack.splitAt(1+args.size) match 
              { case (use, remain) => 
                stack = remain
                use.reverse match {
                  case obj :: args => Console println InvokeStmt(obj, method, args)
                }
              }            
          }
        case InvokeVirtual(clazz, method, args, result) =>
          {
            stack.splitAt(1+args.size) match {
              case (use,remain) =>
                stack = remain
                use.reverse match { case obj :: args =>
                  if(result == "void") 
                    Console println InvokeStmt(obj, method, args)
                  else
                    stack = CallExpr(obj, method, args) :: stack  
                }
            }
                
          }
        case LDC(str) => stack = Constant("String", str) ::  stack
        case Return() => println("return;")
        case _ => System.err println ("unkown instruction:" + x);
      }
    }
    
  }
  
}
