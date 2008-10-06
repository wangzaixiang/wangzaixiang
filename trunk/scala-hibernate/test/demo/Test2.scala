package demo

import java.util.List;

import javax.persistence._;

object Test2 extends Application {
  val emf = Persistence.createEntityManagerFactory("pu");
  val em = emf.createEntityManager();

  em.getTransaction().begin();

  var student = new Student {  name = "wangzx"  }
  em.persist(student);
  
  student = new Student {  name = "rainbow"  }
  em.persist(student);
  
  var tests = em.createQuery("from Student").getResultList()
  
  val testsList = new scala.collection.jcl.BufferWrapper[Student] {
    override def underlying = tests.asInstanceOf[List[Student]]    
  } 
  
  // 我们能否利用Scala来作为数据库查询的Native Query语言，而通过一个所谓的
  // 插入式编译器来实现将其转化成为AST，并自动转化为EJBQL？
  testsList.filter( it => it.name == "wangzx" );
  
  for(st <- testsList){
    Console println st
  }
  
  em.getTransaction().commit();

}
