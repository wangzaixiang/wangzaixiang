package wangzx.gwt.databean.client.model;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.util.List;
import java.util.Map;
import java.util.Vector;

public abstract class AbstractBeanReflection implements BeanReflection {

	protected List<PropertyChangeListener> listeners = new
		Vector<PropertyChangeListener>();
	
	// shared for multi instance and initialize in generated class 
	protected BeanInfo beanInfo;
	protected Map<String,FieldInfo> fieldInfos;
	protected Map<String,FieldInfoXes> fieldInfoXes;
	
	public void addPropertyChangeListener(PropertyChangeListener pcl) {
		listeners.add(pcl);
	}

	public void removePropertyChangeListener(PropertyChangeListener pcl) {
		listeners.remove(pcl);
	}

	protected void firePropertyChange(String field, Object old, Object value) {
		PropertyChangeEvent event = new PropertyChangeEvent(this,field, old, value);
		for(PropertyChangeListener pcl: listeners){
			pcl.propertyChange(event);
		}
	}

	
	public BeanInfo getBeanInfo() {
		return null;
	}


	public FieldInfo getFieldInfo(String field) {
		return null;
	}

	public String getFieldInfoX(String field, String name) {
		return null;
	}

	public abstract Object getField(String field);

	public abstract void setField(String field, Object value);

}
