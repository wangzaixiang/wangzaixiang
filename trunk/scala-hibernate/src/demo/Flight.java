package demo;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Flight implements Serializable {
    Long id;

    @Id @GeneratedValue(strategy=GenerationType.AUTO)
    public Long getId() { return id; }

    public void setId(Long id) { this.id = id; }
    
    public String toString() {
    	return "id:" + id;
    }
}