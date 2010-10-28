package com.google.gwt.uibinder.client;

import com.google.gwt.core.client.JavaScriptObject;

/**
 * JavaBean's path like "bean.field"
 * 
 * TODO add support for bound property
 */
public class BeanPathElement<O, V> extends PathElement<O, V> {

	/**
	 * the function to get the field value
	 */
	private final JavaScriptObject getter;
	
	/**
	 * the function to set the field value
	 */
	private final JavaScriptObject setter;
	
	//private final JavaScriptObject listener;

	public BeanPathElement(O owner, String path, JavaScriptObject getter, JavaScriptObject setter, JavaScriptObject listener){
		super(owner, path);
		this.getter = getter;
		this.setter = setter;
		//this.listener = listener;
		if(owner != null)
			addChangeListener(owner);
		
	}

	@Override
	protected void addChangeListener(O owner) {
		// TODO
		// listener.apply(owner, this);
	}

	@Override
	protected void removeChangeListener(O owner) {
		// TODO
	}

	@Override
	public void setValue(V value) {
		if(setter != null)
			setValue(setter, owner, value);
	}

	private native void setValue(JavaScriptObject setter, O owner, V value) /*-{
		setter.call(null, owner, value);
	}-*/;

	@Override
	public V getValue() {
		return getValue(getter, owner);
	}

	private native V getValue(JavaScriptObject getter, O owner) /*-{
		return getter.call(null, owner);
	}-*/;
	
	
}
