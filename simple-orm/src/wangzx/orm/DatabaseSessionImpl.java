package wangzx.orm;

import java.lang.reflect.Field;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.GenerationType;

import wangzx.orm.EntityMetadata.FieldMetadata;


public class DatabaseSessionImpl extends DatabaseSession {

	private Connection conn;

	public DatabaseSession connection(Connection conn) {
		this.conn = conn;
		return this;
	}

	public Connection connection() {
		return conn;
	}

	@SuppressWarnings("unchecked")
	@Override
	public <T> T map(Class<T> type) {
		return (T) Proxy.newProxyInstance(type.getClassLoader(),
				new Class[] { type }, new DaoInvocationHandler(this));
	}

	@Override
	public <T> Query<T> query(Class<T> type) {
		return new Query<T>(this, type);
	}

	/**
	 * insert operation
	 */
	public void insert(Object bean) throws SQLException {
		try {
			insert0(bean);
		} catch (IllegalArgumentException e) {
			throw new RuntimeException(e);
		} catch (IllegalAccessException e) {
			throw new RuntimeException(e);
		}
	}

	private void insert0(Object bean) throws SQLException,
			IllegalArgumentException, IllegalAccessException {
		EntityMetadata emd = EntityMetadata.resolve(bean.getClass());
		if (emd == null) {
			throw new RuntimeException("Not an entity bean");
		}

		// check for generated id

		StringBuffer part1 = new StringBuffer().append("insert into ").append(
				emd.getTableName()).append("(");
		StringBuffer part2 = new StringBuffer().append(" values (");

		List<String> fields = new ArrayList<String>();
		FieldMetadata identityField = null;

		for (FieldMetadata fmd : emd.getFieldsMetadata()) {

			if (fmd.isId()
					&& fmd.generatedValue() != null
					&& fmd.generatedValue().strategy() == GenerationType.IDENTITY) {
				identityField = fmd;
				continue;
			}

			if (fields.size() > 0) {
				part1.append(",");
				part2.append(",");
			}
			part1.append(fmd.column());
			part2.append("?");
			fields.add(fmd.name());
		}
		part2.append(")");
		part1.append(")").append(part2);

		PreparedStatement stmt = conn.prepareStatement(part1.toString(),Statement.RETURN_GENERATED_KEYS);
		int index = 1;
		for (String fld : fields) {
			FieldMetadata fmd = emd.getFieldMetadata(fld);
			Field javaField = fmd.javaField();

			Object value = javaField.get(bean);
			stmt.setObject(index++, value);
		}

		int count = stmt.executeUpdate();
		if (count == 1) {
			if(identityField != null){
				ResultSet rs = stmt.getGeneratedKeys();
				if (rs.next()) {
					// TODO type convert
					Object generated = rs.getObject(1);
					identityField.javaField().set(bean, generated);
				}
				
			}
		}

	}
}
