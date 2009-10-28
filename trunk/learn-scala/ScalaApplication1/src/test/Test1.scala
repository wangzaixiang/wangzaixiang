/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package test

import java.sql.{ ResultSet, Connection, DriverManager }
import wangzx.jdbc.RichSQL2._

object Test1 {

  class Person {
    var id: Long = _
    var name: String = _
    var age: Int = _
  }

  def main(args: Array[String]) = {

    implicit val conn = DriverManager.getConnection("jdbc:h2:mem:", "sa", "")

    conn << Array("drop table if exists person",
      "create table person(id identity, name varchar not null, age int)")

    // PreparedStatement can used as function
    val insertPerson = conn prepareStatement "insert into person(name, age) values(?,?)"

    transaction {
      insertPerson << "wangzx" << 36 <<!;
      insertPerson << "rainbow" << 34 <<!;
    }

    // simple ORM mapping
    val persons: Stream[Person] = query(classOf[Person], "select * from person")
    for(person <- persons){
      println(<person id={person.id.toString}><name>{person.name}</name><age>{person.age}</age></person>)
    }

    val p2 = query("select * from person")
    for(person <- p2){
      println("id=" + person("ID") + ":name=" + person("NAME"))
    }
  }
 
 
}
