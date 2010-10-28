package wangzx.appflow.client;

import com.google.gwt.event.shared.*;
import com.google.gwt.user.client.ui.AcceptsOneWidget;

public interface Flow extends HasHandlers{
	
	public class NodeEntryEvent extends GwtEvent<NodeEntryEventHandler>{

		public static final GwtEvent.Type<NodeEntryEventHandler> TYPE = new Type<NodeEntryEventHandler>();
		private final Flow flow;
		private final FlowNode node;
		
		public NodeEntryEvent(Flow flow, FlowNode node){
			this.flow = flow;
			this.node = node;	
		}
		
		@Override
		protected void dispatch(NodeEntryEventHandler handler) {
			handler.onNodeEntry(this);
		}

		@Override
		public com.google.gwt.event.shared.GwtEvent.Type<NodeEntryEventHandler> getAssociatedType() {
			return TYPE;
		}

		public Flow getFlow() {
			return flow;
		}

		public FlowNode getNode() {
			return node;
		}
		
	}
	public interface NodeEntryEventHandler extends EventHandler {
		void onNodeEntry(NodeEntryEvent event);
	}

	public class NodeExitEvent extends GwtEvent<NodeExitEventHandler>{

		public static final GwtEvent.Type<NodeExitEventHandler> TYPE = new Type<NodeExitEventHandler>();
		private final Flow flow;
		private final FlowNode node;
	
		public NodeExitEvent(Flow flow, FlowNode node){
			this.flow = flow;
			this.node = node;	
		}

		
		public Flow getFlow() {
			return flow;
		}


		public FlowNode getNode() {
			return node;
		}


		@Override
		protected void dispatch(NodeExitEventHandler handler) {
			handler.onNodeExit(this);
		}

		@Override
		public com.google.gwt.event.shared.GwtEvent.Type<NodeExitEventHandler> getAssociatedType() {
			return TYPE;
		}
		
	}
	public interface NodeExitEventHandler extends EventHandler {
		void onNodeExit(NodeExitEvent event);
	}

	
	void start(AcceptsOneWidget root);
	
	void fireEvent(FlowEvent event);

	public <H extends EventHandler> HandlerRegistration addHandler(
		      GwtEvent.Type<H> type, final H handler);
	
}
