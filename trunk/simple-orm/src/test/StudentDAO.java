package test;

import java.sql.SQLException;
import java.util.List;

import wangzx.orm.annotations.Delete;
import wangzx.orm.annotations.Insert;
import wangzx.orm.annotations.Select;

public interface StudentDAO {

	@Select("select * from t_student")
	List<Student> findAllStudent() throws SQLException;
	
	@Select("select * from t_student where no = ?")
	Student findById(int no) throws SQLException;
	
	@Insert
	Student	insert(Student student) throws SQLException;
	
	@Delete("delete from t_student where no = :1")
	boolean	delete(int no) throws SQLException;
	
	@Delete("delete from t_student where no = #no")
	boolean delete(Student student) throws SQLException;
	
}
