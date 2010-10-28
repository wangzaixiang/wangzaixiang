package wangzx.login.client;


import wangzx.appflow.client.Flow;
import wangzx.appflow.client.Flow.NodeEntryEvent;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.ui.RootPanel;
import com.google.gwt.user.client.ui.SimplePanel;

public class Main implements EntryPoint {
	
	@Override
	public void onModuleLoad() {

		SimplePanel root = new SimplePanel();
		RootPanel.get("login-panel").add(root);
		
		/*
		 * FlowAppPanel panel = new FlowAppContainer();
		 * panel.setFlow(app); 
		 */
		
		/*
		 * FlowNavigator nav = new FlowNavigator();
		 * nav.setFlow(loginApp);
		 * 
		 * loginApp.addHandler NodeEnterEvent, update navigator
		 */
		
		LoginApp loginApp = GWT.create(LoginApp.class);
		
		loginApp.addHandler(Flow.NodeEntryEvent.TYPE, new Flow.NodeEntryEventHandler() {
			
			@Override
			public void onNodeEntry(NodeEntryEvent event) {
				// 
			}
		});
		
		loginApp.start(root);
	}

}
