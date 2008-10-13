package com.hotye.server.net3ecp.handler.ew

class IncreaseEwAccount extends Net3EcpHandler {
  
  val TRANS_CODE = "USER_N_NEWINCREASEFUND"
  var userService: UserService = _
  var ewService: EwService = _
  
  class IncreaseRequest extends Net3EcpRequest {
    transCode = TRANS_CODE
    var account:String = _
    var amount:String = _
  }
  
  class IncreaseResponse extends Net3EcpResponse {
    var balance: String = _
    var instituteSystemTrace: String = _
  }

  override def getTransCode = TRANS_CODE
  override def getRequestClass = new IncreaseRequest
  
  /** 处理充值请求 */
  override def processRequest(req:Net3EcpRequest) = {
    var _request = req.asInstanceOf[IncreaseRequest]
    
    var _user = userService.queryUserByLoginName(_request.account)
    if(_user == null) throw new ApplicationException()
    
    var _amount = BigDecimal(_request.amount) / 100	// 将请求的分转化为元
    
    var _account = ewService.queryEwAccount(_user.userId)
    if(_account == null) throw new ApplicationException()
    
    var _ewJournalNo = ewService updateEwAvailableAccount
      new EwService.UpdateEWAvailableAccountReq {
        var userId = _user.userId  
        var journalNo = 0	
        var amount = _amount 	
        var serviceCode = "ecp_recharge"
        var transType = "A100"
        var remark = "终端充值" 	
        var instituteId = _request.instituteID 
        var instituteTrace = _request.instituteTrace
      }
    
    var _balance, _balance1, _balance2, _balance3: BigDecimal = 0
    
    for(_sub <- ewService.queryEwSubAccount(_user.userId)){
      if(_sub.subTypeCode == "01") _balance1 += _sub.balance * 100L;	// 普通账户
      if(_sub.subTypeCode == "02") _balance2 += _sub.balance * 100L;	// 冻结帐户
      if(_sub.subTypeCode == "03") _balance3 += _sub.balance * 100L;	// 彩票返奖
    }
    _balance = _balance1 + _balance2 + _balance3;
    
    new IncreaseResponse {
      this.balance = _balance + "#" + _balance1 + "#" + _balance2 + "#" + _balance3;
      instituteSystemTrace = _ewJournalNo.toString;      
    }
    
  }
}
