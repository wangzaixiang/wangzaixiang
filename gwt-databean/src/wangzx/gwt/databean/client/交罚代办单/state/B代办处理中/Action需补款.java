package wangzx.gwt.databean.client.交罚代办单.state.B代办处理中;

import wangzx.gwt.databean.client.model.ReflectibleBean;
import wangzx.gwt.databean.client.交罚代办单.FlowAction;
import wangzx.gwt.databean.client.交罚代办单.state.C需补款.State需补款;

/**
 * 这个类主要建模了每个动作中需要访问的字段，在最终生产版本上，是由管理界面动态产生的
 */
@FlowAction(state=State代办处理中.class, next=State需补款.class)
public class Action需补款 implements ReflectibleBean {
	
	String	工单编号;
	String	车牌号;
	String	车牌颜色;	
	String	文书号;

	int	补款金额;
	int	补款方式;	// 枚举类型
	String	补款原因;
	
}
