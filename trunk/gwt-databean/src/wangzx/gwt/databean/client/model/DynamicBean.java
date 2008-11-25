package wangzx.gwt.databean.client.model;

import java.beans.PropertyChangeListener;

import wangzx.gwt.databean.client.model.ReflectibleBean;

/**
 * BeanReflection is generated via GWT Rebind
 */
public interface DynamicBean {

	/**
	 * return the Bean's information
	 */
	BeanInfo getBeanInfo();
	
	/**
	 * return the fields of the bean in the declaration order
	 */
	String[] getFieldNames();
	
	/**
	 * return the FieldInfo for the given field
	 */
	FieldMetaData getFieldInfo(String field);
	
	/**
	 * field read access 
	 */
	Object getField(String field);
	
	/**
	 * field write access
	 */
	void  setField(String field, Object value);
	
	/**
	 * register a PropertyChangeListener
	 */
	void addPropertyChangeListener(PropertyChangeListener pcl);
	
	/**
	 * unregister a PropertyChangeListener
	 */
	void removePropertyChangeListener(PropertyChangeListener pcl);
	
	/**
	 * delegate field access to the real pojo
	 */
	public void setDelegator(ReflectibleBean pojo);
	
	/**
	 * return the underline pojo
	 */
	public ReflectibleBean getDelegator();
	
}
