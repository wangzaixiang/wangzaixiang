package wangzx.gwt.databean.client.model;

import java.lang.annotation.Annotation;
import java.util.HashMap;
import java.util.Map;

public class FieldInfoImpl implements FieldInfo {

	private String category;
	private Class<?> datatype;
	private String description;
	private int fractions;
	private String icon;
	private String label;
	private int length;
	private String regexp;
	private boolean required;
	private String ui;
	private	Map<String, String> extras = new HashMap<String, String>();
	private Class<?> enumKey;
	private	EnumType<?>[] enumerations;
	private boolean updateEditable;
	private boolean createEditable;
	
	public FieldInfoImpl category(String category){
		this.category = category;
		return this;
	}
	public FieldInfoImpl datatype(Class<?> datatype){
		this.datatype = datatype;
		return this;
	}
	public FieldInfoImpl description(String description){
		this.description = description;
		return this;
	}
	public FieldInfoImpl fractions(int fractions){
		this.fractions = fractions;
		return this;
	}
	public FieldInfoImpl icon(String icon){
		this.icon = icon;
		return this;
	}
	public FieldInfoImpl label(String label){
		this.label = label;
		return this;
	}
	public FieldInfoImpl length(int length){
		this.length = length;
		return this;
	}
	public FieldInfoImpl regexp(String regexp){
		this.regexp = regexp;
		return this;
	}
	public FieldInfoImpl required(boolean required){
		this.required = required;
		return this;
	}
	public FieldInfoImpl ui(String ui){
		this.ui = ui;
		return this;
	}
	public FieldInfoImpl enumKey(Class<?> enumKey){
		this.enumKey = enumKey;
		return this;
	}
	public FieldInfoImpl extra(String key, String value) {
		extras.put(key, value);
		return this;
	}
	public FieldInfoImpl enumerations(EnumType<?>[] enumerations) {
		this.enumerations = enumerations;
		return this;
	}
	public FieldInfoImpl createEditable(boolean createEditable) {
		this.createEditable = createEditable;
		return this;
	}
	public FieldInfoImpl updateEditable(boolean updateEditable) {
		this.updateEditable = updateEditable;
		return this;
	}

	
	public String category() {
		return this.category;
	}

	public Class<?> datatype() {
		return this.datatype;
	}

	public String description() {
		return this.description;
	}

	public int fractions() {
		return this.fractions;
	}

	public String icon() {
		return this.icon;
	}

	public String label() {
		return this.label;
	}

	public int length() {
		return this.length;
	}

	public String regexp() {
		return this.regexp;
	}

	public boolean required() {
		return this.required;
	}

	public String ui() {
		return this.ui;
	}
	
	public String extra(String key){
		return extras.get(key);
	}

	public Class<? extends Annotation> annotationType() {
		return FieldInfo.class;
	}

	public Class<?> enumKey() {
		return this.enumKey;
	}
	
	public EnumType<?>[] enumerations() {
		return enumerations;
	}
	public boolean createEditable() {
		return this.createEditable;
	}
	public boolean updateEditable() {
		return this.updateEditable;
	}
	
	
	

}
