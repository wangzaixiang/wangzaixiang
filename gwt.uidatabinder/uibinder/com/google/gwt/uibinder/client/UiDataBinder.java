package com.google.gwt.uibinder.client;

/**
 * Mark interface for GWT.create
 * 
 * extends UiBinder interface with data binding support.
 * 
 * @author wangzaixiang@gmail.com
 */
public interface UiDataBinder<U, O> {

	U createAndBindUi(O owner);
	
	void flush();
	
	void save();
}
