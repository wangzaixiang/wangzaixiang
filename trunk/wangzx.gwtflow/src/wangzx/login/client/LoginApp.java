/**
 * 
 */
package wangzx.login.client;

import wangzx.appflow.client.Flow;
import wangzx.appflow.client.FlowEvent;

// see LoginApp.flow.xml
public interface LoginApp extends Flow {
	
	// Event can be either the same package of the App
	// or as the inner class of App
	public class LoginSuccessEvent extends FlowEvent {
		String username;
		
		public LoginSuccessEvent(String username){
			this.username = username;
		}
	}
	public class RegisterEvent extends FlowEvent {}
	public class ForgotPasswordEvent extends FlowEvent {}
	
	
}