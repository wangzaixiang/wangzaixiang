/**
 * 
 */
package wangzx.orm;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * a mapper which map a ResultSet to given JavaBean
 * 
 * @author wangzaixiang
 */
public interface ResultSetMapper<T> {
	
	T	map(ResultSet rs) throws SQLException;
	
	void	map(ResultSet rs, T instance) throws SQLException;
	
}