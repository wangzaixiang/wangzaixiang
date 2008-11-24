package wangzx.gwt.databean.client.model;

import java.lang.annotation.Annotation;

public class BeanInfoImpl implements BeanInfo {

	private String description;
	private	String icon;
	private	String label;
	
	public BeanInfoImpl(){
	}
	
	public BeanInfoImpl label(String label){
		this.label = label;
		return this;
	}
	public BeanInfoImpl description(String description){
		this.description = description;
		return this;
	}
	public BeanInfoImpl icon(String icon){
		this.icon = icon;
		return this;
	}
	
	
	public String description() {
		return description;
	}

	public String icon() {
		return icon;
	}

	public String label() {
		return label;
	}

	public Class<? extends Annotation> annotationType() {
		return BeanInfo.class;
	}

}
