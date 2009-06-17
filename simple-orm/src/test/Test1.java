package test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

import wangzx.orm.DatabaseSession;

public class Test1 {

	public static void main(String[] args) throws SQLException {

		Class<?> driver = org.h2.Driver.class;
		System.out.println(driver);
		Connection conn = DriverManager.getConnection("jdbc:h2:db/test", "sa",
				""); // 获得一个连接

		DatabaseSession dbSession = DatabaseSession.createInstance(conn);

		StudentDAO dao = dbSession.map(StudentDAO.class);

		// test 1 -- select a list
		{
			System.out.println("\n\ntest finaAllStudent ");

			List<Student> students = dao.findAllStudent();
			for (Student s : students) {
				System.out.println(s);
			}
		}

		// test 2 -- select a record, and using parameter
		{
			System.out.println("\n\ntest finaById ");

			Student student = dao.findById(1);
			System.out.println("student 1 = " + student);
		}

		// test 3
		{
			System.out.println("\n\ntest direct sql");
			List<Student> students = dbSession.query(Student.class) //
					.sql("select * from t_student") //
					.queryList();

			for (Student s : students) {
				System.out.println(s);
			}
		}

		// test 4 --
		{
			Student student = new Student();
			student.name = "wangzhixing";
			student.address = "guangzhou";
			// dao.insert(student);
			dbSession.insert(student);

			System.out.println("insert a student:" + student);
		}
		
		{ // test 5
			Student student = new Student();
			student.name = "wangzhixing";
			student.address = "guangzhou";
			// dao.insert(student);
			dao.insert(student);

			System.out.println("insert a student:" + student);
			
		}
		
		{
			// 获得一个sequence的当前值
			Integer integer = dbSession.query(Integer.class).sql("select test_seq.nextval from dual").querySingle();
			System.out.println("nextval is " + integer);

			integer = dbSession.query(Integer.class).sql("select test_seq.nextval from dual").querySingle();
			System.out.println("nextval is " + integer);

		}

		// JaQue support
		/*{
			List<Student> students = dbSession.query(Student.class).jaque(
					new Filter<Student>() {

						public boolean isMatched(Student it) {
							return it.name == "wangzx";
						}
					}).queryList();
			for (Student s : students) {
				System.out.println(s);
			}
		}*/

	}

}
