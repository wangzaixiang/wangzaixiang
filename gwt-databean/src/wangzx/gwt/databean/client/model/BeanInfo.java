package wangzx.gwt.databean.client.model;

public @interface BeanInfo {

	/**
	 * Bean Name
	 */
	String name() default "";
	
	/**
	 * 显示名称
	 */
	String label() default "";

	/**
	 * 帮助信息
	 */
	String	description() default "";

	/**
	 * 缺省图标
	 */
	String icon() default "";
	
	/**
	 * 申明Bean的Category
	 */
	Category[] categories() default {};
	
}
