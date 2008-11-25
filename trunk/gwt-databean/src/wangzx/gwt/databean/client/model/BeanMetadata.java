package wangzx.gwt.databean.client.model;

import java.lang.annotation.Annotation;

public class BeanMetadata implements BeanInfo {

	private	String name;
	private String description;
	private	String icon;
	private	String label;
	private Category[] categories;
	
	public BeanMetadata(){
	}
	
	public BeanMetadata label(String label){
		this.label = label;
		return this;
	}
	public BeanMetadata description(String description){
		this.description = description;
		return this;
	}
	public BeanMetadata icon(String icon){
		this.icon = icon;
		return this;
	}
	public BeanMetadata name(String name){
		this.name = name;
		return this;
	}
	public BeanMetadata categories(Category[] categories){
		this.categories = categories;
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

	public String name() {
		return name;
	}

	public Category[] categories() {
		return categories;
	}

	public Class<? extends Annotation> annotationType() {
		return BeanInfo.class;
	}


}
