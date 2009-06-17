package wangzx.orm;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Query<T> {
	
	private	Class<T>	clazz;
	
	private	ResultSetMapper<T> mapper;
	
	/**
	 * full SQL statement for this query
	 */
	private	String	sqlStatement;
	private Object[] args;
	
	private final DatabaseSessionImpl session;

	
	public Query(DatabaseSessionImpl session, Class<T> clazz){
		this.session = session;
		this.clazz = clazz;
		this.mapper = ResultSetMapperHelper.getMapper(clazz);
	}
	

	public Query<T> sql(String statement, Object... args){
		this.sqlStatement = statement;
		this.args = args;
		return this;
	}
	
	/*
	public Query<T> jaque(Filter<T> filter){
		return this;
	}
	*/
	
	public List<T> queryList() throws SQLException{
		
		if(sqlStatement == null){
			// TODO using default 
		}
	
		PreparedStatement stmt = session.connection().prepareStatement(sqlStatement);
		if(args != null){
			for(int i=1; i<=args.length; i++) {
				stmt.setObject(i, args[i-1]);
			}
		}
		ResultSet rs = stmt.executeQuery();

		List<T> results = new ArrayList<T>();
		while(rs.next()){
			T bean = mapper.map(rs);
			results.add(bean);
		}
		
		return results;
		
	}
	
	public T	querySingle() throws SQLException {
		List<T> list = queryList();
		if(list.size() == 0)
			return null;
		else if(list.size()==1){
			return list.get(0);
		}
		else 
			throw new RuntimeException("expect 0..1 result but returns " + list.size() );
	}
	
	@Override
	public String toString() {
		return "Query[type:" + clazz + "]";
	}
	
}
