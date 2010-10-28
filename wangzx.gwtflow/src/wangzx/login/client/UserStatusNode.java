package wangzx.login.client;

import wangzx.appflow.client.BaseFlowNode;
import wangzx.login.client.LoginApp.LoginSuccessEvent;

import com.google.gwt.user.client.ui.Label;
import com.google.gwt.user.client.ui.Widget;

public class UserStatusNode extends BaseFlowNode {
	
	@Override
	protected Widget createView() {
		LoginSuccessEvent event = (LoginSuccessEvent) enterEvent;	
		return new Label("Hello " + event.username);
	}

}
