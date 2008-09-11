package wangzx.java2js.js

object AST {

  abstract class JsNode
  case class JsCatch extends JsNode
  abstract case class JsExpression extends JsNode
      case class JsArrayAccess extends JsExpression
      case class JsBinaryOperation extends JsExpression
      case class JsConditional extends JsExpression
      case class JsInvocation extends JsExpression
      abstract case class JsLiteral extends JsExpression
          case class JsBooleanLiteral extends JsLiteral
          case class JsNullLiteral extends JsLiteral
          case class JsNumberLiteral extends JsLiteral
          case class JsRegExp extends JsLiteral
          case class JsStringLiteral extends JsLiteral
          case class JsThisRef extends JsLiteral
      case class JsNameRef extends JsExpression
      case class JsNew extends JsExpression
      abstract case class JsUnaryOperation extends JsExpression
          case class JsPostfixOperation extends JsUnaryOperation
          case class JsPrefixOperation extends JsUnaryOperation
  case class JsParameter extends JsNode
  case class JsProgram extends JsNode
  case class JsPropertyInitializer extends JsNode
  abstract case class JsStatement extends JsNode
      case class JsBlock extends JsStatement
          case class JsGlobalBlock
      case class JsBreak extends JsStatement
      case class JsContinue extends JsStatement
      case class JsDebugger extends JsStatement
      case class JsDoWhile extends JsStatement
      case class JsEmpty extends JsStatement
      case class JsFor extends JsStatement
      case class JsForIn extends JsStatement
      case class JsIf extends JsStatement
      case class JsLabel extends JsStatement
      case class JsReturn extends JsStatement
      case class JsSwitch extends JsStatement
      case class JsThrow extends JsStatement
      case class JsTry extends JsStatement
      case class JsVars extends JsStatement
      case class JsWile extends JsStatement
  abstract case class JsSwitchMember extends JsNode
      case class JsCase extends JsSwitchMember
      case class JsDefault extends JsSwitchMember
  case class JsVar extends JsNode
  
  
}
