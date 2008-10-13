package com.hotye.server.net3ecp.handler.ew

import javax.persistence._
import java.util.Date
import TransType._, SubAcctType._

class EWLogicServiceImpl extends EwService {
  
  var em:EntityManager = _;
    
  override def queryEwAccount(userId:Int) : EWAccount = {
    val ew = em.find(classOf[EWAccount], userId)
    if(ew != null){
      val hasAvailable = ew.subAccounts.filter(_.subTypeCode == Available).length > 0
      if(!hasAvailable) {
        // ew.subAccounts.add(createSubAcctType("01", userId);
      }
      return ew; 
    }
    null
  }
  
  /**
   * 更改电子钱包可用账户余额
   * 
   * @return 返回电子钱包交易流水号
   */
  def updateEwAvailableAccount(_req: EwService.UpdateEWAvailableAccountReq): Int = {
    
    _req.transType match {
      case RechargeEcp | RechargeGnete | FreezeToAvailable =>
        assert(_req.amount > 0)
      case DirectPay | AvailableToFreeze =>
        assert(_req.amount < 0)
      case _ =>
        assert(false)
    }
    
    val _account = queryEwAccount(_req.userId)
    assert(_account != null, "用户尚未开通电子钱包")
    
    var _accAvail, _accFreeze: EWSubAccount = null
    var _total: BigDecimal = 0
    var _subs = _account.subAccounts;
    _subs.filter(_.subTypeCode==Available) :::_subs.filter(_.subTypeCode==Freeze) match {
      case a :: b :: Nil =>
        _accAvail = a; _accFreeze = b;
        _total = a.balance + b.balance	// 可用余额+冻结余额
      case a :: Nil =>
        _accAvail = a
        _total = _accAvail.balance
      case _ =>
    }

    assert(_accAvail.balance + _req.amount > 0, "余额不足")
    assert(_total<=3000, "电子钱包上线为：3000元，已经超额!")
    
    //修改子账户
    { sub: EWSubAccount =>
      sub.balance = sub.balance + _req.amount
      sub.lastUpdateTime = new Date
      
      if(_req.amount>0 && _req.transType != FreezeToAvailable)
        sub.accumulatedTotal += _req.amount
    }.apply(_accAvail)
        
    // 记录流水
    val _ewJournal = new EWJournal {
      journalNo = _req.journalNo
      transTime = new Date
      subAcctNo = _accAvail.subAcctNo
      acctNo = _accAvail.acctNo
      transAmount = _req.amount
      subAcctBalance = _accAvail.balance
      subTypeCode = _accAvail.subTypeCode
      servTypeCode = null //TODO
      transTypeCode = _req.transType
      remark = _req.remark
      transStatus = "00"
      instituteID = _req.instituteId
      instituteTrace = _req.instituteTrace
      transWhere = if(servTypeCode == "ECP_RECHARGE") "ecp" else "web"
    }
    em.persist(_ewJournal)
    
    return _ewJournal.journalNo
  }
  
  def queryEwSubAccount(userId:Int): List[EWSubAccount] = {
    val account = queryEwAccount(userId)
    return if(account==null) null else account.subAccounts
  }

}
