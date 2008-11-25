package wangzx.gwt.databean.client.model;

public interface AttachmentContainer {

	/**
	 * 当前组件是否容许附件
	 */
	boolean allowAttachments();

	/**
	 * 当前组件的附件的相对访问路径
	 */
	String	getResourcePath();
	
}
