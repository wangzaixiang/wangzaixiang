package wangzx.newuibinder.client;

import com.google.gwt.core.client.GWT;
import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.uibinder.client.UiDataBinder;
import com.google.gwt.uibinder.client.UiHandler;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.Widget;

public class SimpleForm extends Composite {

	private static Binder uiBinder = GWT.create(Binder.class);

	interface Binder extends UiDataBinder<Widget, SimpleForm> {
	}

	Box<String> userName = new Box<String>();
	Box<String> password = new Box<String>();
	

	public SimpleForm() {
		initWidget(uiBinder.createAndBindUi(this));
	}
	
	@UiHandler("click")
	void onClick(ClickEvent ev){
		System.out.println("On Click");
		userName.setValue("Hello World", true);
	}

}
