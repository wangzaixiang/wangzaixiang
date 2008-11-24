package wangzx.gwt.databean.client.test;

import wangzx.gwt.databean.client.model.FieldInfo;
import wangzx.gwt.databean.client.model.ReflectibleBean;

public class 需补款 implements ReflectibleBean {
	
	@FieldInfo(createEditable=false)
	private	long	工单编号;
	
	@FieldInfo(createEditable=false)
	private	String	车牌号;
	
	@FieldInfo(createEditable=false)
	private	String	车牌颜色;
	
	@FieldInfo(createEditable=false)
	private	String	文书号;

	private	int	补款金额;
	private	int	补款方式;	// 枚举类型
	private	String	补款原因;
	
	public String get车牌号() {
		return 车牌号;
	}
	public void set车牌号(String 车牌号) {
		this.车牌号 = 车牌号;
	}
	public String get车牌颜色() {
		return 车牌颜色;
	}
	public void set车牌颜色(String 车牌颜色) {
		this.车牌颜色 = 车牌颜色;
	}
	public String get文书号() {
		return 文书号;
	}
	public void set文书号(String 文书号) {
		this.文书号 = 文书号;
	}
	public int get补款金额() {
		return 补款金额;
	}
	public void set补款金额(int 补款金额) {
		this.补款金额 = 补款金额;
	}
	public int get补款方式() {
		return 补款方式;
	}
	public void set补款方式(int 补款方式) {
		this.补款方式 = 补款方式;
	}
	public String get补款原因() {
		return 补款原因;
	}
	public void set补款原因(String 补款原因) {
		this.补款原因 = 补款原因;
	}
	
	
}
