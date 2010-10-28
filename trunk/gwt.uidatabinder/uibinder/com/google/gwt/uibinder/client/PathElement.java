package com.google.gwt.uibinder.client;


/**
 * Base Path Element
 * 
 */
@SuppressWarnings("unchecked")
public abstract class PathElement<O, V> {

	protected O owner;

	final protected String path;

	protected PathElement<V, ?> next;

	protected Path<?> ownerPath;

	protected PathElement(O owner, String path) {
		this.path = path;
		this.owner = owner;
	}

	public void append(PathElement next) {
		if (this.next == null) {
			this.next = (PathElement<V, ?>) next;
			next.setOwner(getValue());
		} else {
			this.next.append(next);
		}
	}

	public void setOwner(O owner) {
		O oldOwner = this.owner;
		this.owner = owner;
		if (oldOwner != null) {
			removeChangeListener(oldOwner);
		}
		if (owner != null) {
			addChangeListener(owner);
		}
	}

	protected void onValueChanged(V newValue) {
		if (next != null) {
			next.setOwner(newValue);
		} else { // last
			if (ownerPath.peer != null) {
				Path<V> peer = (Path<V>) ownerPath.peer;
				peer.setValue(newValue);
			}
		}
	}

	protected abstract void addChangeListener(O owner);

	protected abstract void removeChangeListener(O owner);

	public abstract void setValue(V value);

	public abstract V getValue();
}
