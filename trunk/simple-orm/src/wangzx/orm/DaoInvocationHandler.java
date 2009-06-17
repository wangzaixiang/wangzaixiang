package wangzx.orm;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.util.List;

import wangzx.orm.annotations.Insert;
import wangzx.orm.annotations.Select;


public class DaoInvocationHandler implements InvocationHandler {
	
	private DatabaseSessionImpl session;
	
	public DaoInvocationHandler(DatabaseSessionImpl session){
		this.session = session;
	}

	@Override
	public Object invoke(Object proxy, Method method, Object[] args)
			throws Throwable {
		
		if(method.getAnnotation(Select.class) != null)
			return doSelect(proxy, method, args);
		else if(method.getAnnotation(Insert.class) != null)
			return doInsert(proxy, method, args); 
		else
			return null;
	}

	private Object doInsert(Object proxy, Method method, Object[] args) throws SQLException {
		if(args.length == 1)
			session.insert(args[0]);
		
		return null;
	}

	private Object doSelect(Object proxy, Method method, Object[] args) throws SQLException {
				
		Type returnType = method.getGenericReturnType();
		if(returnType instanceof ParameterizedType ){
			Type rawType = ((ParameterizedType) returnType).getRawType();
			Type[] typeArguments = ((ParameterizedType) returnType).getActualTypeArguments();
			
			if(List.class == rawType){ // return an list of 
				if(typeArguments.length == 1 && typeArguments[0] instanceof Class) {
					Class<?> beanType = (Class<?>) typeArguments[0];
					// verifyEntityType();
					return selectList(proxy, method, args, beanType);
				}
			}
		}
		else if(returnType instanceof Class){
			Class<?> beanType = (Class<?>) returnType;
			if(verifyEntityType(beanType)){
				return selectSingle(proxy, method, args, beanType);
			}
		}
		
		throw new RuntimeException("return type:" + returnType + " is not unstandand");
	}

	private Object selectSingle(Object proxy, Method method, Object[] args,
			Class<?> type) throws SQLException {
		Select select = method.getAnnotation(Select.class);
		List<?> list = session.query(type).sql(select.value(), args).queryList();
		if(list.size() == 0)
			return null;
		else if(list.size() == 1)
			return list.get(0);
		else {
			throw new RuntimeException("Expect 1 result but return " + list.size() + " records");
		}
	}

	private boolean verifyEntityType(Class<?> type) {
		return true;
	}

	private Object selectList(Object proxy, Method method, Object[] args,
			Class<?> type) throws SQLException {

		Select select = method.getAnnotation(Select.class);
		return session.query(type).sql(select.value(), args).queryList();
		
	}
	

}
