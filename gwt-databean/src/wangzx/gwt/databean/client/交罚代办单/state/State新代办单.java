package wangzx.gwt.databean.client.交罚代办单.state;

import wangzx.gwt.databean.client.model.FieldInfo;
import wangzx.gwt.databean.client.model.FieldInfo.UI;
import wangzx.gwt.databean.client.交罚代办单.FlowAction;

public class State新代办单 {

	
	@FlowAction(next = State已发起代办.class)
	public class Action发起代办 {

		@FieldInfo(enumKey=String.class, ui=UI.checkbox)
		String	代办公司;
		
	}
	
}
