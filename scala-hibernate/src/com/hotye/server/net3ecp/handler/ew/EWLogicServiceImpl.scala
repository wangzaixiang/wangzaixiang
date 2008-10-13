package com.hotye.server.net3ecp.handler.ew

import javax.persistence._
import java.util.Date
import TransType._
import SubAcctType._

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
      case RechargeEcp | RechargeGnete | FreezeToAvailable => // 充值类交易
        assert(_req.amount > 0, "金额不正确")
      case DirectPay | AvailableToFreeze =>	// 支付、冻结类交易
        assert(_req.amount < 0, "金额不正确")
      case _ =>	
        assert(false, "无效交易类型")
    }
    
    val _account = queryEwAccount(_req.userId)
    assert(_account != null, "用户尚未开通电子钱包")
    
    var _accAvail, _accFreeze: EWSubAccount = null
    var _total: BigDecimal = _req.amount
    _account.subAccounts.find(_.subTypeCode==Available) match {
      case Some(x) =>  _accAvail = x;    _total += x.balance
      case None =>
    }
    _account.subAccounts.find(_.subTypeCode==Freeze) match {
      case Some(x) =>  _accFreeze = x;    _total += x.balance
      case None=>
    }

    assert(_accAvail != null, "用户未开通电子钱包")
    assert(_accAvail.balance + _req.amount > 0, "余额不足")
    assert(_total<=3000, "电子钱包上线为：3000元，已经超额!")
    
    //修改子账户记录
    { 
      _accAvail.balance = _accAvail.balance + _req.amount
      _accAvail.lastUpdateTime = new Date
      
      if(_req.amount>0 && _req.transType != FreezeToAvailable)
        _accAvail.accumulatedTotal += _req.amount
    }
        
    // 记录流水
    val _ewJournal = new EWJournal {
      journalNo = _req.journalNo
      transTime = new Date
      subAcctNo = _accAvail.subAcctNo
      acctNo = _accAvail.acctNo
      transAmount = _req.amount
      subAcctBalance = _accAvail.balance
      subTypeCode = _accAvail.subTypeCode
      servTypeCode = _req.serviceCode
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
