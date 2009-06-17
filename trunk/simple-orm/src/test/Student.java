package test;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 * <pre>
 * create table t_student(no int identity primary key,
 * name varchar(16) not null, 
 * address varchar(128)
 * )
 * </pre>
 * 
 */
@Entity
@Table(name = "t_student")
public class Student {

	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	public	int	no;
	
	public	String	name;
	
	public	String	address;
		
	public String toString() {
		return String.format("no = %s, name = %s, address = %s", no, name, address);
	}
	
}
