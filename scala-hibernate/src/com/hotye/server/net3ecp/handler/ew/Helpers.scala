package com.hotye.server.net3ecp.handler.ew

import java.util.Date;

trait UserService {
  def queryUserByLoginName(loginName:String): User;
}

object TransType {
  val DirectPay = "A000"
  val AvailableToFreeze = "A001"
  val RechargeEcp = "A100"
  val RechargeGnete = "A101"
  val FreezeToAvailable = "A109"
}
object SubAcctType {
  val Available = "01"
  val Freeze = "02"
  val Bonus = "03"
}

object EwService {
  abstract class UpdateEWAvailableAccountReq {
    var userId: Int
    var journalNo: Int
    var amount: BigDecimal
    var serviceCode: String
    var transType: String
    var remark: String
    var instituteId: String
    var instituteTrace: String
  }  
  
}

trait EwService {
  def queryEwAccount(userId:Int) : EWAccount
  def updateEwAvailableAccount(req: EwService.UpdateEWAvailableAccountReq): Int
  def queryEwSubAccount(userId:Int): List[EWSubAccount]
}

class User {
  var userId: Int = _
  var userName: String = _
  var nickName: String = _
  var password: String = _
  var email: String = _
  var emailVerfivied: Boolean = _
  var mobile: String = _
  var mobileVerified: Boolean  = _
  var name: String = _
  var certType: String = _
  var certNo: String = _
  var regFrom: String = _
  var regTime: Date = _
  var lastLogonTime: Date = _
  var status: Char = _
  var gradCode: String = _
  var sex: Char = _
  var qq: String = _
  var msn: String = _
}

class EWAccount {
  var acctNo: Int = _
  var userType: Char = _
  var activeTime: Date = _
  var lastUpdateTime: Date = _
  var status: Char = _
  var mac: String = _
  var subAccounts: List[EWSubAccount] = _
}

class EWSubAccount {
  var subAcctNo: Int = _
  var acctNo : Int = _
  var subTypeCode: String = _
  var balance: BigDecimal = _
  var lastUpdateTime: Date = _
  var accumulatedTotal: BigDecimal = _
  
}

class EWJournal {
  var ewJournalNo:Int = _
  var journalNo:Int = _
  var subAcctNo:Int = _
  var acctNo:Int = _
  var transTime: Date = _
  var transTypeCode: String = _
  var transAmount: BigDecimal = _
  var subAcctBalance: BigDecimal = _
  var subTypeCode:String = _
  var remark: String = _
  var transWhere: String = _
  var ecpTransCode: String = _
  var servTypeCode:String = _
  var transStatus: String = _
  var reverseStatus: String = _
  var auditStatus: String = _
  var instituteID: String = _
  var instituteTrace: String = _
  
}

class ApplicationException extends Exception {
  
}

