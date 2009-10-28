/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package scalaapplication1

import java.sql.{DriverManager, Statement}
import wangzx.jdbc.RichSQL._

object Main {

  private val setup = Array("drop table if exists person",
  """create table person (
      id identity,
      type int,
      name varchar not null
     )
  """);

  def go = {

    val rnd = new java.util.Random

    implicit val conn = DriverManager.getConnection("jdbc:h2:mem", "sa", "");
    implicit val stmt: Statement = conn << setup;
    val insertPerson = conn prepareStatement "insert into person(type, name) values(?,?)"
    val names = Array("Ross", "Lynn", "John", "Terri", "Steve", "Zobeyda");
    for(val name<-names){
      insertPerson << rnd.nextInt(10) << name <<!
    }

    conn.transaction {
      println("no record with wangzx will be added")
      insertPerson << rnd.nextInt(10) << "wangzx" <<! ;
      throw new RuntimeException
    }

    conn.transaction {
      println("but record with rainbow will be added");
      insertPerson << rnd.nextInt(10) << "rainbow" <<!
    }

    for(val person <- query("select * from person", rs=>Person(rs,rs,rs))){
      println(person.toXML)
    }

    /* conn.doTransaction {
     * }
     */

   }

  case class Person(id:Long, tpe: Int, name: String){
    def toXML = <person id={id.toString} type={tpe.toString}>{name}</person>
  }

  def main(args: Array[String]) :Unit = {
    go
  }

}
