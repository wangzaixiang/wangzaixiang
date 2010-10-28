package wangzx.login.client;

import wangzx.appflow.client.FlowEvent;
import wangzx.appflow.client.FlowNode;

import com.google.gwt.core.client.GWT;
import com.google.gwt.event.shared.EventBus;
import com.google.gwt.event.shared.EventHandler;
import com.google.gwt.event.shared.GwtEvent;
import com.google.gwt.event.shared.HandlerRegistration;
import com.google.gwt.event.shared.SimpleEventBus;
import com.google.gwt.event.shared.GwtEvent.Type;
import com.google.gwt.user.client.ui.AcceptsOneWidget;


public class LoginApp_Impl implements LoginApp{

	protected AcceptsOneWidget parent;
	protected FlowNode	currentNode;
	private EventBus eventBus;
	
	@Override
	public void fireEvent(FlowEvent event) {
	}
	
	public void fireEvent(FlowNode from, FlowEvent event){
		if(from instanceof LoginNode){
			if(event instanceof LoginSuccessEvent){
				go( GWT.<FlowNode>create(UserStatusNode.class), event);
				return;
			}
			else if(event instanceof RegisterEvent){
				go( GWT.<FlowNode>create(RegisterNode.class), event);
				return;
			}
			else if(event instanceof ForgotPasswordEvent){
				go(GWT.<FlowNode>create(ForgotPasswordNode.class), event);
				return;
			}
		}
		fireEvent(event);
	}
	
	private void go(FlowNode node, FlowEvent event){
		if(currentNode != null){
			fireEvent(new NodeExitEvent(this, currentNode));
		}
		fireEvent(new NodeEntryEvent(this, node));
		node.enter(parent, event);
		currentNode = node;
	}

	@Override
	public void start(AcceptsOneWidget parent) {		
		this.parent = parent;
		
		LoginNode node = GWT.create(LoginNode.class);
		go(node, null);
	}

	@Override
	public <H extends EventHandler> HandlerRegistration addHandler(
			Type<H> type, H handler) {
		if(eventBus == null)
			eventBus = new SimpleEventBus();
		return eventBus.addHandler(type, handler);
	}

	@Override
	public void fireEvent(GwtEvent<?> event) {
		if(eventBus != null)
			eventBus.fireEvent(event);
	}
	

}
