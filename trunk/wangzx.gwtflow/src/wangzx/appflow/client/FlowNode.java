package wangzx.appflow.client;

import com.google.gwt.user.client.ui.AcceptsOneWidget;

public interface FlowNode {

	void setFlow(Flow flow);
	Flow getFlow();
	
	void enter(AcceptsOneWidget parent, FlowEvent event);
	
	int	getStepNo();
	String getTitle();
}
