package wangzx.appflow.client;

import com.google.gwt.user.client.ui.AcceptsOneWidget;
import com.google.gwt.user.client.ui.Widget;


public abstract class BaseFlowNode implements FlowNode {
	
	protected Flow flow;
	protected FlowEvent enterEvent;

	public void setFlow(Flow flow){
		this.flow = flow;
	}

	@Override
	public Flow getFlow() {
		return flow;
	}

	@Override
	public void enter(AcceptsOneWidget parent, FlowEvent event) {
		this.enterEvent = event;
		parent.setWidget(createView());
	}

	protected abstract Widget createView();
	
	public int getStepNo() {
		return -1;
	}

	public String getTitle() {
		return null;
	}
}
