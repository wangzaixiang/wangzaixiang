package com.google.gwt.uibinder.client;


import com.google.gwt.event.logical.shared.ValueChangeEvent;
import com.google.gwt.event.logical.shared.ValueChangeHandler;
import com.google.gwt.event.shared.HandlerRegistration;
import com.google.gwt.user.client.ui.HasValue;

@SuppressWarnings("unchecked")
public class ValuePathElement<O,V> extends PathElement<O,V> implements ValueChangeHandler<V> {
	
	//HasValue<T> owner;
	
	HandlerRegistration	registration;
		
	public ValuePathElement(HasValue<V> owner){
		super((O) owner, "value");
		if(owner != null)
			addChangeListener((O)owner);
	}

	@Override
	public void onValueChange(ValueChangeEvent<V> event) {
		super.onValueChanged(event.getValue());
	}

	@Override
	protected void addChangeListener(O owner) {
		HasValue<V> valueOwner = (HasValue<V>) owner;
		registration = valueOwner.addValueChangeHandler(this);
	}

	@Override
	protected void removeChangeListener(O owner) {
		registration.removeHandler();
	}

	@Override
	public void setValue(V value) {
		HasValue<V> valueOwner = (HasValue<V>) owner;
		valueOwner.setValue(value, true);
	}

	@Override
	public V getValue() {
		HasValue<V> valueOwner = (HasValue<V>) owner;
		return valueOwner.getValue();
	}
	
}
