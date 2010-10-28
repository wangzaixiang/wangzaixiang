package wangzx.newuibinder.client;

import com.google.gwt.event.logical.shared.ValueChangeEvent;
import com.google.gwt.event.logical.shared.ValueChangeHandler;
import com.google.gwt.event.shared.GwtEvent;
import com.google.gwt.event.shared.HandlerManager;
import com.google.gwt.event.shared.HandlerRegistration;
import com.google.gwt.user.client.ui.HasValue;

public class Box<T> implements HasValue<T> {

	private T value;
	private HandlerManager handlerManager;

	public T getValue() {
		return value;
	}

	public void setValue(T value) {
		setValue(value, false);
	}

	@Override
	public void fireEvent(GwtEvent<?> event) {
		if (handlerManager != null)
			handlerManager.fireEvent(event);
	}

	@Override
	public HandlerRegistration addValueChangeHandler(
			ValueChangeHandler<T> handler) {
		if (handlerManager == null)
			handlerManager = new HandlerManager(this);
		return handlerManager.addHandler(ValueChangeEvent.getType(), handler);
	}

	@Override
	public void setValue(T value, boolean fireEvents) {
		T old = this.value;
		this.value = value;
		if (fireEvents) {
			if (value != null && !value.equals(old)) {
				ValueChangeEvent.fire(this, value);
			} else if (value == null && old != null) {
				ValueChangeEvent.fire(this, value);
			}
		}
	}

}
