
//
function main(){
	
	var db = context.module("demo.db");
	
	db.script(<sql>
	create table student {
		name	char(10) primary key,
		sex		char(1),
		birthday	date,
		email	varchar(32)
	}
	</sql>);
	
	db.insert("student", {
			'name': 'wangzx',
			'sex':'M',
			'birthday': '1973-03-22',
			'email':'wangzaixiang@gmail.com'
		});
	
	db.update("student", {
		'name': 'wangzx',
		'email': 'wangzaixiang2@gmail.com'
		});
	
	var name = "wangzx";
	var email = 'wangzx@gmail.com';
	db.sql("update student set email = :email where name = :name");
	
	db.sql("update student set email = :email where name = :name",
		{ 	'email': 'wangzx@gmail.com',
			'name':	'wangzx'
		});
	
}