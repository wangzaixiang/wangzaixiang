package wangzx.gwt.databean.client.model;

public @interface FieldInfo {
	
	public enum UI {
		text,
		textarea,
		password, 
		calendar, 
		select,
		checkbox,
		radiobox,
		file,
		image
	}
	

	/**
	 * 显示名称
	 */
	String label() default "";

	/**
	 * 长度
	 */
	int length() default -1;
	
	/**
	 * 对于number类型，指定小数点后的位数
	 */
	int fractions() default -1;
	
	/**
	 * 验证正则表达式
	 */
	String	regexp() default "";
	
	/**
	 * 是否必须
	 */
	boolean required() default false;

	/**
	 * 帮助信息
	 */
	String	description() default "";

	/**
	 * 显示ui组件
	 * text, textarea, password, calendar, select, checkbox, file, image
	 */
	UI ui() default UI.text;
	
	/**
	 * 缺省图标
	 */
	String icon() default "";
	
	/**
	 * 新对象时是否可以编辑
	 */
	boolean createEditable() default true;
	
	/**
	 * 更新对象时是否可以编辑
	 */
	boolean updateEditable() default true;
	
	/**
	 * 属性分组
	 */
	String	category() default "";
	
	/**
	 * 数据类型，一般由定义进行推出。
	 * <ul>支持：
	 * <li>byte, short, char, int, long, float, double
	 * <li>Byte, Short, Character, Integer, Long, Float, Double
	 * <li>Date
	 * </ul>
	 */
	Class<?>	datatype() default Object.class;
	
	/**
	 * 如果当前字段是一个Enum类型，说明该Enum的key类型
	 */
	Class<?>	enumKey() default Object.class;

}
