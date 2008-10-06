package demo

import javax.persistence._;

import scala.reflect._;

@Entity
class Student {
  
  @Id 
  @GeneratedValue
  var id: Int = _;
  
  var name: String = _;
  
  override def toString = "Id:" + id + " name:" + name
}
