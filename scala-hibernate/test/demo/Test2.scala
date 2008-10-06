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
  
  for(st <- testsList){
    Console println st
  }
  
  em.getTransaction().commit();

}
