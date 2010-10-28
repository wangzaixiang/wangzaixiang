package wangzx.newuibinder.client;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.user.client.ui.RootPanel;

public class Main implements EntryPoint {

	@Override
	public void onModuleLoad() {

		 SimpleForm form = new SimpleForm();
		 RootPanel.get().add(form);

//		bindTest2();

	}

//	static class Student {
//
//		Box<String> name = new Box<String>();
//
//		public Box<String> getName() {
//			return name;
//		}
//
//		public void setName(Box<String> name) {
//			this.name = name;
//		}
//
//	}
//
//	Student student = new Student();
//	
//	
////	interface DataBinder {
//				
//		void bind(
//				@BindPath("wUserName") Main view,
//				@BindPath("student.name") Main model
//		);
//		
//	}
//	
//	{
//		DataBinder binder = GWT.create(DataBinder.class);
//		binder.bind(this, this);
//	}

//	void bindTest() {
//
//		TextBox wUserName = new TextBox();
//		Box<String> userName = new Box<String>();
//		RootPanel.get().add(wUserName);
//
//		Path<String> path1 = new Path<String>()
//				.append(new ValuePathElement<TextBox, String>(wUserName));
//		Path<String> path2 = new Path<String>().append(new ValuePathElement(
//				userName));
//
//		path1.bind(path2);
//
//		wUserName.setValue("Changed", true);
//		assert userName.getValue().equals("Changed");
//
//		userName.setValue("Modified", true);
//		assert wUserName.getValue().equals("Modified");
//
//	}

//	void bindTest2() {
//
//		TextBox wUserName = new TextBox();
//		RootPanel.get().add(wUserName);
//		
//
//		Path<String> path1 = new Path<String>().appendValuePart(wUserName);
//		
//		Path<String> path2 = new Path<String>()
//			.appendBeanProperty(this, "student", wangzx_newuibinder_client_Main_getStudent(), null)
//			.appendBeanProperty(null, "name", wangzx_newuibinder_client_Main_Student_getName(), null)
//			.appendValuePart(null);
//		
//		path1.bind(path2);
//
//		wUserName.setValue("Changed", true);
//		assert student.name.getValue().equals("Changed");
//
//		student.name.setValue("Modified", true);
//		assert wUserName.getValue().equals("Modified");
//
//	}

//	private native JavaScriptObject wangzx_newuibinder_client_Main_getStudent() /*-{
//		return function(bean){
//			return bean.@wangzx.newuibinder.client.Main::student;
//		}
//	}-*/;
//
//	private native JavaScriptObject wangzx_newuibinder_client_Main_setStduent() /*-{
//		return function(bean, value){
//			bean.@wangzx.newuibinder.client.Main::student = value;
//		}
//	}-*/;
//
//	private native JavaScriptObject wangzx_newuibinder_client_Main_Student_getName() /*-{
//		return function(bean){
//			return bean.@wangzx.newuibinder.client.Main.Student::getName()();
//		}
//	}-*/;
//
//	private native JavaScriptObject setter2() /*-{
//		return function(bean, value){
//			bean.@wangzx.newuibinder.client.Main.Student::setName(Lwangzx/newuibinder/client/Box;)(value);
//		}
//	}-*/;

}
