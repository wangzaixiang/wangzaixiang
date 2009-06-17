package test;

import jaque.expressions.LambdaExpression;
import junit.framework.TestCase;

public class TestJaQue extends TestCase {

	public static class StudentFilter {
		
		public boolean invoke(Student it) {
			return it.name == "wangzx";
		}
		
	}
	
	public void testLambaExpression(){
		StudentFilter filter = new StudentFilter();
		
		LambdaExpression<StudentFilter> expression = LambdaExpression.parse(filter);
		
		System.out.println(expression);
		
	}
	
}
