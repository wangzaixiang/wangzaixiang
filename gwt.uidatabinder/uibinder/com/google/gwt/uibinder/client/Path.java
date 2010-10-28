package com.google.gwt.uibinder.client;


import com.google.gwt.core.client.JavaScriptObject;
import com.google.gwt.user.client.ui.HasValue;


@SuppressWarnings("unchecked")
public class Path<T> {

	PathElement<?,?> head;
	
	Path<T> peer;
	
	void setValue(T value){
		PathElement tail = getLastPathElement();
		tail.setValue(value);
	}
	
	T	getValue(){
		PathElement last = getLastPathElement();
		return (T) last.getValue();
	}

	private PathElement getLastPathElement() {
		PathElement it = head;
		while(it.next != null)
			it = it.next;
		
		return it;
	}

	public Path<T> append(PathElement pe) {
		pe.ownerPath = this;
		if(head == null)
			head = pe;
		else getLastPathElement().append(pe);
		return this;
	}

	public Path bind(Path<T> that) {
		peer = that;
		that.peer = this;
		return this;
	}
	
	public Path<T> appendBeanProperty(Object owner, String property, JavaScriptObject getter, JavaScriptObject setter){
		return append(new BeanPathElement(owner, property, getter, setter, null));
	}
	
	public Path<T> appendValuePart(HasValue owner){
		return append(new ValuePathElement(owner));
	}
}
