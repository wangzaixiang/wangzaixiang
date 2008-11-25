package wangzx.gwt.databean.client.交罚代办单.state;

import wangzx.gwt.databean.client.model.FieldInfo;
import wangzx.gwt.databean.client.model.ReflectibleBean;
import wangzx.gwt.databean.client.交罚代办单.FlowAction;

public class State已发起代办 {

	@FlowAction(next = State电子眼已认罚.class)
	public static class Action电子眼已认罚 {
		
	}

	@FlowAction(state=State已发起代办.class, next=State需补款.class)
	public static class Action需补款 implements ReflectibleBean {
		
		String	工单编号;
		String	车牌号;
		String	车牌颜色;	
		String	文书号;

		int	补款金额;
		int	补款方式;	// 枚举类型
		String	补款原因;
		
	}

	@FlowAction(state=State已发起代办.class, next=State需补资料.class)
	public static class Action需补资料 implements ReflectibleBean {
		
		@FieldInfo(createEditable=false)
		long	工单编号;
		
		@FieldInfo(createEditable=false)
		String	车牌号;
		
		@FieldInfo(createEditable=false)
		String	车牌颜色;
		
		@FieldInfo(createEditable=false)
		String	文书号;

		int	资料类型;
		String	补资料说明;
				
	}
	
	@FlowAction(next = State异地已缴纳.class)
	public static class Action异地已缴纳 {
		
	}
	
	@FlowAction(next = State无缴纳记录.class)
	public static class Action无缴纳记录 {
		
	}
	
	@FlowAction(next = State需退款.class)
	public static class Action需退款 {
		
	}
	
}
