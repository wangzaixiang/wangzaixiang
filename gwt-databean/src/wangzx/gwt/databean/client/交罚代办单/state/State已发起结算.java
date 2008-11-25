package wangzx.gwt.databean.client.交罚代办单.state;

import wangzx.gwt.databean.client.交罚代办单.FlowAction;

public class State已发起结算 {

	@FlowAction(next = State已结算.class)
	static class Action结算完成 {
		
	}
	
}
