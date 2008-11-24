package wangzx.gwt.databean.client.model;

import java.beans.PropertyChangeListener;

import wangzx.gwt.databean.client.model.ReflectibleBean;

/**
 * BeanReflection is generated via GWT Rebind
 */
public interface BeanReflection {

	public void setDelegator(ReflectibleBean book);
	
	public ReflectibleBean getDelegator();
	
	BeanInfo getBeanInfo();
	
	String[] getFieldNames();
	
	FieldInfo getFieldInfo(String field);
	
	String getFieldInfoX(String field, String name);
	
	Object getField(String field);
	
	void  setField(String field, Object value);
	
	void addPropertyChangeListener(PropertyChangeListener pcl);
	
	void removePropertyChangeListener(PropertyChangeListener pcl);
	
}
