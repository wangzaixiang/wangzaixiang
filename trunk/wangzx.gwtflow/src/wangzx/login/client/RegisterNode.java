package wangzx.login.client;

import wangzx.appflow.client.BaseFlowNode;

import com.google.gwt.uibinder.client.UiHandler;
import com.google.gwt.user.client.ui.Widget;

public class RegisterNode extends BaseFlowNode {

	@Override
	protected Widget createView() {
		return null;
	}
	
	@UiHandler("btnRegister")
	void onRegisterClick(){
		
		// do register here
		flow.fireEvent(new LoginApp.LoginSuccessEvent("wangzx"));
		
	}

}
