package demo;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class TestFlight {
	
	public static void main(String[] args) {
		
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("pu");
		EntityManager em = emf.createEntityManager();

		em.getTransaction().begin();
		
		Flight f = new Flight();
		em.persist(f);
		em.flush();

		List<Flight> result = em.createQuery("from Flight").getResultList();
		for(Flight flight: result){
			System.out.println(flight);
		}
				
		em.getTransaction().commit();
	}

}
