package wangzx.gwt.databean.client.交罚代办单.state.B代办处理中;

import wangzx.gwt.databean.client.model.FieldInfo;
import wangzx.gwt.databean.client.model.ReflectibleBean;
import wangzx.gwt.databean.client.交罚代办单.FlowAction;
import wangzx.gwt.databean.client.交罚代办单.state.D需补资料.State需补资料;

@FlowAction(state=State代办处理中.class, next=State需补资料.class)
public class Action需补资料 implements ReflectibleBean {
	
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
