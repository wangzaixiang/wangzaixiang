package wangzx.gwt.databean.client.test;

import java.util.Date;

import wangzx.gwt.databean.client.model.BeanInfo;
import wangzx.gwt.databean.client.model.EnumInfo;
import wangzx.gwt.databean.client.model.EnumType;
import wangzx.gwt.databean.client.model.FieldInfo;
import wangzx.gwt.databean.client.model.FieldInfoX;
import wangzx.gwt.databean.client.model.FieldInfoXes;
import wangzx.gwt.databean.client.model.ReflectibleBean;
import wangzx.gwt.databean.client.model.BeanReflection;
import wangzx.gwt.databean.client.ui.SimpleBeanForm;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.ui.RootPanel;

/**
 * <ul>Test features:
 * <li> GWT.create(IsXDataBean) works
 * <li> SimpleXBeanForm works on edit mode
 * <li> support String field with length
 * <li> support textarea
 * <li> support enumeration
 * <li> support date
 * <li> support decimal number
 * </ul>
 *
 */
public class TestCase1 implements EntryPoint {

	public static enum BookStatus implements EnumType<Integer>{
		Available(0, "可用"),
		BorrowOut(1, "借出"),
		Missed(2, "丢失");

		private Integer key;
		private String label;
		private BookStatus(int key, String label){
			this.key = key;
			this.label = label;
		}
		
		public Integer key() {
			return key;
		}

		public String label() {
			return label;
		}
	}
	
	@BeanInfo
	public static class Book implements ReflectibleBean {
		
		@FieldInfo(label="书名", length=18)
		private	String name;
		
		@FieldInfo(label="作者", length=12)
		private	String author;
		
		@FieldInfo(label="出版社")
		private	String publisher;
		
		@FieldInfo(label="出版日期")
		private	Date publishDate;
		
		@FieldInfo(label="价格")
		private double price;
		
		@FieldInfo(label="状态")
		private BookStatus status;
		
		@FieldInfo(label="简要介绍", ui="textarea")
		@FieldInfoXes(
				{	@FieldInfoX(name="textarea.width", value="80"),
					@FieldInfoX(name="textarea.height", value="5") } )
		private	String	abbr;
		
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public String getAuthor() {
			return author;
		}
		public void setAuthor(String author) {
			this.author = author;
		}
		public String getPublisher() {
			return publisher;
		}
		public void setPublisher(String publisher) {
			this.publisher = publisher;
		}
		public double getPrice() {
			return price;
		}
		public void setPrice(double price) {
			this.price = price;
		}
		public BookStatus getStatus() {
			return status;
		}
		public void setStatus(BookStatus status) {
			this.status = status;
		}
		public Date getPublishDate() {
			return publishDate;
		}
		public void setPublishDate(Date publishDate) {
			this.publishDate = publishDate;
		}
		public String getAbbr() {
			return abbr;
		}
		public void setAbbr(String abbr) {
			this.abbr = abbr;
		}
		
	}
	
	public void onModuleLoad() {
		
		BeanReflection bean = GWT.create(Book.class);
		Book book = new Book();
		bean.setDelegator(book);
		
		SimpleBeanForm form = new SimpleBeanForm(bean);
		RootPanel.get().add(form);
		
		//
		
	}

}
