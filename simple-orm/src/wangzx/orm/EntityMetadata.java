package wangzx.orm;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

public class EntityMetadata {

	static class FieldMetadata {
		
		private String	name;	// field name
		private String	column;	// using the @Column metadata
		private Field	javaField;
		
		private boolean	isId;
		private	GeneratedValue generatedValue;
		
		public boolean isId()	{	return isId;	}
		public String name()	{	return name;	}
		public String column()	{	return column;	}
		public Field javaField()	{ 	return javaField; }
		public GeneratedValue generatedValue()	{ return generatedValue; }
		// generator
	}
	
	private Class<?> type;
	
	private Table	tableInfo;
	
	private Map<String, FieldMetadata> fields = new HashMap<String, FieldMetadata>(); 
	private List<FieldMetadata> id = new ArrayList<FieldMetadata>();	// the id fields 
	
	public static EntityMetadata resolve(Class<?> type){
		
		Entity entity = type.getAnnotation(Entity.class);
		if(entity == null)
			return null;

		EntityMetadata emd = new EntityMetadata();
		emd.type = type;
		
		emd.tableInfo = type.getAnnotation(Table.class);
		
		List<Class<?>> supportedTypes = Arrays.asList(new Class<?>[]{
				boolean.class, Boolean.class, byte.class, Byte.class, 	//
				short.class, Short.class, char.class, Character.class, 	//
				int.class, Integer.class, long.class, Long.class,	//
				float.class, Float.class,	double.class,	Double.class,	//
				Date.class, Time.class, Timestamp.class, BigDecimal.class,	//
				String.class, byte[].class
		});
		
		for(Field field: type.getDeclaredFields()){
			
			// check transient
			if(field.getAnnotation(Transient.class)!=null || Modifier.isTransient(field.getModifiers()) ){
				continue;
			}
			
			// only support given type
			if(supportedTypes.indexOf(field.getType())<0){
				continue;
			}
			
			FieldMetadata fmd = new FieldMetadata();
			fmd.name = field.getName();
			fmd.javaField = field;
			fmd.javaField.setAccessible(true);	// even for private access
			if(field.getAnnotation(Column.class)!= null){
				Column column = field.getAnnotation(Column.class);
				fmd.column = column.name();
			} else {
				fmd.column = "";
			}
			
			if("".equals(fmd.column))
				fmd.column = field.getName();
			
			if(field.getAnnotation(Id.class) != null){
				fmd.isId = true;
				emd.id.add(fmd);
			}
			fmd.generatedValue = field.getAnnotation(GeneratedValue.class);

			emd.fields.put(fmd.name, fmd);
		}
		
		
		return emd;
	}


	public String getTableName() {
		String tableName = (tableInfo == null) ? "" : tableInfo.name();
		tableName = (tableName.equals("")) ? type.getSimpleName() : tableName;
		return tableName;
	}


	public Collection<FieldMetadata> getFieldsMetadata() {
		return fields.values();
	}


	public FieldMetadata getFieldMetadata(String fieldName) {
		return fields.get(fieldName);
	}
	
	public List<FieldMetadata> getId(){
		return id;
	}
	
}
