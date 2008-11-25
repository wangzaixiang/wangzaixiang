package wangzx.gwt.databean.client.交罚代办单;

public @interface FlowAction {

	Class<?> state() default Object.class;

	Class<?> next();

}
