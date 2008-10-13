package com.hotye.server.net3ecp.handler.ew

class Net3EcpRequest {
  var transCode: String = _
  var instituteID: String = _
  var instituteTrace: String = _
  
}

class Net3EcpResponse {
  var responseCode:String = _
  var responseMsg: String = _
}

trait Net3EcpHandler {
  def getTransCode: String
  def processRequest(request:Net3EcpRequest): Net3EcpResponse;
  def getRequestClass: Net3EcpRequest;
}
