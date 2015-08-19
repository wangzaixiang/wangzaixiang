#A new designed lightweight ORM tool

# Introduction #

先看一段示范代码：http://code.google.com/p/wangzaixiang/source/browse/trunk/simple-orm/src/test/Test1.java

核心对象：DatabaseSession 将一个java.sql.Connection 封装成为一个orm会话。

DatabaseSession.map(Interface dao) 支持自动根据接口生成一个实现类，在接口上通过@annotation申明数据库操作。你可以直接使用DatabaseSession提供的方法，查询、插入、修改、删除对象。

如何理解DatabaseSession呢?DatabaseSession是一个将iBatis的特性和Spring JDBCTemplate相结合的概念产品

```
List<Student> students = dbSession.query(Student.class) //
	.sql("select * from t_student where name like ? and no < ?", "wang%", 10) //
	.queryList();

for (Student s : students) {
	System.out.println(s);
}
```

# Details #

Add your content here.  Format your content with:
  * Text in **bold** or _italic_
  * Headings, paragraphs, and lists
  * Automatic links to other wiki pages