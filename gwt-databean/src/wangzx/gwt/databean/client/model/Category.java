package wangzx.gwt.databean.client.model;

/**
 * 定义一个字段分类，可以实现简单的交互界面，即当某个值发生变化时，
 * 给定Category的字段是否显示
 * 
 * 
 */
public @interface Category {
	
	String name();
	
	String dependField() default "";
	String dependValue() default "";	// default value is name()
}
