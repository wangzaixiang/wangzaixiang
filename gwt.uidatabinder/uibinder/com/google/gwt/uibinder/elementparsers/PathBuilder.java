package com.google.gwt.uibinder.elementparsers;

import com.google.gwt.core.client.JavaScriptObject;
import com.google.gwt.core.ext.typeinfo.JClassType;
import com.google.gwt.core.ext.typeinfo.JField;
import com.google.gwt.core.ext.typeinfo.JMethod;
import com.google.gwt.core.ext.typeinfo.JType;
import com.google.gwt.core.ext.typeinfo.NotFoundException;
import com.google.gwt.core.ext.typeinfo.TypeOracle;
import com.google.gwt.uibinder.rebind.UiBinderWriter;
import com.google.gwt.user.client.ui.HasValue;

public class PathBuilder {
	
	
	public static abstract class PathElementBuilder {
		JClassType ownerType;
		String	path;
		JType valueType;
		
		PathElementBuilder next;

		public PathElementBuilder getNext() {
			return next;
		}
		
	}
	public static class ValuePathElementBuilder extends PathElementBuilder{
		
	}
	public static class BeanPathElementBuilder extends PathElementBuilder {
		
		JMethod	getter;
		JMethod	setter;
		JField	field;	// when no getter/setter, field used
		
		public String getterMethodName(){
			return ownerType.getQualifiedSourceName().replace('.', '_') + "_get_" + path;
		}
		
		public String setterMethodName(){
			return ownerType.getQualifiedSourceName().replace('.', '_') + "_set_" + path;
		}
		
		public String getterMethod(){
			if(getter == null && field != null) 
				return String.format("private native JavaScriptObject %s() /*-{return function(bean){return bean.@%s::%s; }}-*/;",
					getterMethodName(), ownerType.getQualifiedSourceName(), field.getName());
			if(getter != null){
				return String.format("private native JavaScriptObject %s() /*-{return function(bean){ return bean.@%s::%s()();}}-*/;",
					getterMethodName(), ownerType.getQualifiedSourceName(), getter.getName());
			}
			throw new RuntimeException();
		}

		public String setterMethod(){
			if(setter == null && field != null) 
				return String.format("private native JavaScriptObject %s() /*-{return function(bean, value){bean.@%s::%s = value; }}-*/;",
					setterMethodName(), ownerType.getQualifiedSourceName(), field.getName());
			if(setter != null){
				return String.format("private native JavaScriptObject %s() /*-{return function(bean, value){ return bean.@%s::%s(%s)(value);}}-*/;",
					setterMethodName(), ownerType.getQualifiedSourceName(), setter.getName(), valueType.getJNISignature());
			}
			throw new RuntimeException();
		}

	}
	
	String		defaultPackage;
	TypeOracle	oracle;
	String		rootName;
	PathElementBuilder builders[];
	JType	valueType;

	
	public PathElementBuilder[] getBuilders() {
		return builders;
	}


	private PathElementBuilder builder(UiBinderWriter writer, JClassType type, String path) {
		JClassType hasValueType = writer.getOracle().findType(HasValue.class.getName());
		if(hasValueType.isAssignableFrom(type) && "value".equals(path)){
			ValuePathElementBuilder builder = new ValuePathElementBuilder();
			builder.ownerType = type;
			builder.path = path;
			builder.valueType = findGetValueReturnType(type);
			return builder;
		}
		else {
			BeanPathElementBuilder builder = new BeanPathElementBuilder();
			builder.ownerType = type;
			builder.path = path;

			// find getter
			builder.getter = findMethod(type, "get" + captical(path), new JType[0]);
			if(builder.getter != null){
				JType valueType = builder.getter.getReturnType();
				builder.setter = findMethod(type, "set" + captical(path), new JType[]{valueType});
			}
			builder.field = findPackageAccessibleField(type, path, defaultPackage);
			if(builder.getter != null)
				builder.valueType = builder.getter.getReturnType();
			else if(builder.field != null)
				builder.valueType = builder.field.getType();
			
			return builder;
		}
	}
	
	private JType findGetValueReturnType(JClassType type){
		JMethod method = findMethod(type, "getValue", new JType[0]);
		if(method != null)
			return method.getReturnType();
		else
			return null;
	}
	
	private JField findPackageAccessibleField(JClassType type, String path, String accessPackage) {
		JField field = type.getField(path);
		if(field != null) {
			if(field.isPublic())
				return field;
			if(field.isDefaultAccess() && type.getPackage().getName().equals(accessPackage))
				return field;
		}
		
		JClassType superclass = type.getSuperclass();
		if(superclass != null){
			return findPackageAccessibleField(superclass, path, accessPackage);
		}
		else return null;
		
		
	}

	private JMethod findMethod(JClassType type, String name, JType[] args) {
		
		try {
			JMethod method = type.getMethod(name, args);
			return method;
		}
		catch(NotFoundException ex){
		}
		
		JClassType superclass = type.getSuperclass();
		if(superclass != null)
			return findMethod(superclass, name, args);
		else
			return null;
		
	}

	private String captical(String path) {
		return path.substring(0, 1).toUpperCase() + path.substring(1);
	}

	public PathBuilder(UiBinderWriter writer, String rootName, JClassType ownerType, String pathStr) {
		this.defaultPackage = ownerType.getPackage().getName();
		this.rootName = rootName;
		String pathes[] = pathStr.split("\\.");
		for(int i = 0; i<pathes.length; i++)
			pathes[i] = pathes[i].trim();
		init(writer, rootName, ownerType, pathes);
	}
	
	private void init(UiBinderWriter writer, String ownerName, JClassType type, String pathes[]) {
		builders = new PathElementBuilder[pathes.length];
		JType current = type;
		for(int i = 0; i<pathes.length; i++){
			String path = pathes[i];
			if(current instanceof JClassType)
				builders[i] = builder(writer, (JClassType)current, path);
			else {
				throw new RuntimeException("Not a valid type" + current + " require JClassType");  
			}
			current = builders[i].valueType;
		}
		for(int i=0; i<builders.length-1; i++){
			builders[i].next = builders[i+1];
		}
		this.valueType = builders[builders.length-1].valueType;
	}
	
	/**
	 * <code>
	 * bindPathes.add(
				new Path().appendValuePart(wUserName).bind(
						new Path().appendBeanProperty(owner, "userName", 
								wangzx_newuibinder_client_SimpleForm_getUserName(), null)
								.appendValuePart(null)));
	 * </code>
	 */
	public String toSource(){
		String stmt = "new Path()";
		String owner = this.rootName;
		for(PathElementBuilder builder: builders){
			if(builder instanceof ValuePathElementBuilder){
				stmt = stmt + String.format(".appendValuePart(%s)", owner);
			}
			else {
				BeanPathElementBuilder beanBuilder = (BeanPathElementBuilder) builder;
				stmt = stmt + String.format(".appendBeanProperty(%s, \"%s\", %s(), %s)", 
						owner, beanBuilder.path, beanBuilder.getterMethodName(), 
						beanBuilder.next == null ? beanBuilder.setterMethodName() + "()": "null"
						);
			}
			owner = "null";
		}
		return stmt;
	}

}
