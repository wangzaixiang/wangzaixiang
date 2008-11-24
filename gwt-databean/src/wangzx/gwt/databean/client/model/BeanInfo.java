package wangzx.gwt.databean.client.model;

public @interface BeanInfo {

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

}
