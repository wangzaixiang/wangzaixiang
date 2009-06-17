package wangzx.orm;

import java.sql.Connection;
import java.sql.SQLException;

public abstract class DatabaseSession {

	public static DatabaseSession createInstance(){
		return new DatabaseSessionImpl();
	}
	
	public static DatabaseSession createInstance(Connection conn){
		return createInstance().connection(conn);
	}

	protected abstract DatabaseSession connection(Connection conn);

	/**
	 * generate a dynamic implementation for the given interface
	 */
	public abstract <T> T map(Class<T> type);

	public abstract <T> Query<T> query(Class<T> type);

	public abstract void insert(Object bean) throws SQLException;

}
