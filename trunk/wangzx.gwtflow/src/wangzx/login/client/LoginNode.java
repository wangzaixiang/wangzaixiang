package wangzx.login.client;


import wangzx.appflow.client.BaseFlowNode;
import wangzx.appflow.client.Bind;

import com.google.gwt.core.client.GWT;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.uibinder.client.UiHandler;
import com.google.gwt.user.client.ui.PasswordTextBox;
import com.google.gwt.user.client.ui.TextBox;
import com.google.gwt.user.client.ui.Widget;

public class LoginNode extends BaseFlowNode {

	interface Binder extends UiBinder<Widget, LoginNode> {}
	
	@UiField
	TextBox wUserName;
	
	@UiField
	PasswordTextBox wPassword;
	
	@Bind("wUserName.value")
	String userName;
	
	@Bind("wPassword.value")
	String password;
			
	protected Widget createView(){
		return GWT.<Binder>create(Binder.class).createAndBindUi(this);
	}
	
	public void setUserName(String userName){
		this.userName = userName;

		boolean isValid = false;
		wUserName.setStyleDependentName("invalid", isValid==false);
	}
	
	public boolean validate(){
		return true;
	}

	@UiHandler("btnLogin")
	void onLoginClick(){
		validate();
		flow.fireEvent(new LoginApp.LoginSuccessEvent(userName));
	}
	
	@UiHandler("btnRegister")
	void onRegisterClick(){
		flow.fireEvent(new LoginApp.RegisterEvent());
	}
	
	void onForgotPasswordClick(){
		flow.fireEvent(new LoginApp.ForgotPasswordEvent());
	}

}
