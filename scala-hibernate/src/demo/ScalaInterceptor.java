package demo;

import javax.persistence.Entity;

import org.hibernate.EmptyInterceptor;

public class ScalaInterceptor extends EmptyInterceptor {

	@Override
	public String getEntityName(Object entity) {
		Class<?> clazz = entity.getClass();
		
		Entity annotation = clazz.getAnnotation(Entity.class);
		if(annotation != null)
			return clazz.getName();
		
		if(clazz.getEnclosingClass() != null){
			// for scala inner type
			Class<?> _super = clazz.getSuperclass();
			annotation = _super.getAnnotation(Entity.class);
			if(annotation != null)
				return _super.getName();
		}
		
		return null;
	}
	
}
