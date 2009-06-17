package wangzx.orm;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.HashMap;

import test.Student;

public class ResultSetMapperHelper {

	static class StudentMapper implements ResultSetMapper<Student> {

		@Override
		public Student map(ResultSet rs) throws SQLException {
			Student student = new Student();
			map(rs, student);
			return student;
		}

		@Override
		public void map(ResultSet rs, Student it) throws SQLException {
			it.no = rs.getInt("no");
			it.name = rs.getString("name");
			it.address = rs.getString("address");
		}
		
	}
	
	@SuppressWarnings("unchecked")
	static class PrimitiveMapper implements ResultSetMapper {

		private Class<?> primitive;

		public PrimitiveMapper(Class type){
			this.primitive = type;
		}
		
		@Override
		public Object map(ResultSet rs) throws SQLException {
			if(primitive == boolean.class || primitive == Boolean.class)
				return rs.getBoolean(1);
			if(primitive == byte.class || primitive == Byte.class)
				return rs.getByte(1);
			if(primitive == short.class || primitive == Short.class)
				return rs.getShort(1);
			if(primitive == int.class || primitive == Integer.class)
				return rs.getInt(1);
			if(primitive == long.class || primitive == Long.class)
				return rs.getLong(1);
			if(primitive == float.class || primitive == Float.class)
				return rs.getFloat(1);
			if(primitive == double.class || primitive == Double.class)
				return rs.getDouble(1);
			if(primitive == Date.class)
				return rs.getDate(1);
			if(primitive == Time.class)
				return rs.getTime(1);
			if(primitive == String.class)
				return rs.getString(1);
			if(primitive == BigDecimal.class)
				return rs.getBigDecimal(1);
			if(primitive == Timestamp.class)
				return rs.getTimestamp(1);
			throw new UnsupportedOperationException();
		}

		@Override
		public void map(ResultSet rs, Object instance) throws SQLException {
			throw new UnsupportedOperationException();
		}
		
	}
	
	private static HashMap<Class<?>, ResultSetMapper<?>> mappers = new HashMap<Class<?>, ResultSetMapper<?>>();
	
	static {
		mappers.put(byte.class, new PrimitiveMapper(byte.class));
		mappers.put(Byte.class, new PrimitiveMapper(Byte.class));
		mappers.put(short.class, new PrimitiveMapper(short.class));
		mappers.put(Short.class, new PrimitiveMapper(Short.class));
		mappers.put(int.class, new PrimitiveMapper(int.class));
		mappers.put(Integer.class, new PrimitiveMapper(Integer.class));
		mappers.put(long.class, new PrimitiveMapper(long.class));
		mappers.put(Long.class, new PrimitiveMapper(Long.class));
		mappers.put(float.class, new PrimitiveMapper(float.class));
		mappers.put(Float.class, new PrimitiveMapper(Float.class));
		mappers.put(double.class, new PrimitiveMapper(double.class));
		mappers.put(Double.class, new PrimitiveMapper(Double.class));
		mappers.put(String.class, new PrimitiveMapper(String.class));
		mappers.put(Date.class, new PrimitiveMapper(Date.class));
		mappers.put(Time.class, new PrimitiveMapper(Time.class));
		mappers.put(Timestamp.class, new PrimitiveMapper(Timestamp.class));
		mappers.put(BigDecimal.class, new PrimitiveMapper(BigDecimal.class));
		mappers.put(byte[].class, new PrimitiveMapper(byte[].class));
	}
	
	@SuppressWarnings("unchecked")
	public static <T> ResultSetMapper<T> getMapper(Class<T> clazz) {
		
		ResultSetMapper<?> find = mappers.get(clazz);
		if(find != null)
			return (ResultSetMapper<T>) find;
		
		ResultSetMapper<T> mapper = null;
		{
			if(clazz == Student.class)
				mapper = (ResultSetMapper<T>) new StudentMapper();
			mappers.put(Student.class, mapper);
			return mapper;
		}
	}
	
}
