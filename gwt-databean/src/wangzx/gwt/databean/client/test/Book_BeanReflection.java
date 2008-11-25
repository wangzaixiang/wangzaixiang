package wangzx.gwt.databean.client.test;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import wangzx.gwt.databean.client.model.AbstractBeanReflection;
import wangzx.gwt.databean.client.model.BeanInfo;
import wangzx.gwt.databean.client.model.BeanInfoImpl;
import wangzx.gwt.databean.client.model.FieldInfo;
import wangzx.gwt.databean.client.model.FieldMetaData;
import wangzx.gwt.databean.client.model.FieldInfoXes;
import wangzx.gwt.databean.client.model.ReflectibleBean;
import wangzx.gwt.databean.client.model.FieldInfo.UI;
import wangzx.gwt.databean.client.test.TestCase1.Book;
import wangzx.gwt.databean.client.test.TestCase1.BookStatus;

public class Book_BeanReflection extends AbstractBeanReflection {

	private static BeanInfo shared_beanInfo;
	private static Map<String, FieldInfo> shared_fieldInfos;
	private static Map<String, FieldInfoXes> shared_fieldInfoXes;

	protected Book delegator;

	public ReflectibleBean getDelegator() {
		return delegator;
	}

	public void setDelegator(ReflectibleBean delegator) {
		this.delegator = (Book) delegator;
	}

	static {
		shared_beanInfo = new BeanInfoImpl().label("Book");
		shared_fieldInfos = new HashMap<String, FieldInfo>();
		shared_fieldInfos.put("name", new FieldMetaData().label("书名")
				.length(18));
		shared_fieldInfos.put("author", new FieldMetaData().label("作者").length(
				12));
		shared_fieldInfos.put("publisher", new FieldMetaData().label("出版社"));
		shared_fieldInfos.put("publishDate", new FieldMetaData().label("出版日期"));
		shared_fieldInfos.put("price", new FieldMetaData().label("价格"));
		shared_fieldInfos.put("status", new FieldMetaData().label("状态").enumKey(Integer.class)
				.enumerations(BookStatus.values()));
		shared_fieldInfos.put("abbr", new FieldMetaData().label("简要介绍").ui(UI.textarea)
				.extra("textarea.width","80").extra("textarea.height","5"));
		
	}

	public Book_BeanReflection() {
		this.beanInfo = shared_beanInfo;
		this.fieldInfos = shared_fieldInfos;
		this.fieldInfoXes = shared_fieldInfoXes;
	}

	public Object getField(String field) {
		if ("name".equals(field)) {
			return delegator.getName();
		} else if ("author".equals(field)) {
			return delegator.getAuthor();
		} else if ("publisher".equals(field)) {
			return delegator.getPublisher();
		} else if ("publishDate".equals(field)) {
			return delegator.getPublishDate();
		} else if ("price".equals(field)) {
			return delegator.getPrice();
		} else if ("status".equals(field)) {
			return delegator.getStatus();
		} else if ("abbr".equals(field)) {
			return delegator.getAbbr();
		}
		return null;
	}

	public void setField(String field, Object value) {
		Object old = getField(field);
		if ("name".equals(field)) {
			delegator.setName((String) value);
		} else if ("author".equals(field)) {
			delegator.setAuthor((String) value);
		} else if ("publisher".equals(field)) {
			delegator.setPublisher((String) value);
		} else if ("publishDate".equals(field)) {
			delegator.setPublishDate((Date) value);
		} else if ("price".equals(field)) {
			delegator.setPrice((Double) value);
		} else if ("status".equals(field)) {
			delegator.setStatus((BookStatus) value);
		} else if ("abbr".equals(field)) {
			delegator.setAbbr((String) value);
		}
		firePropertyChange(field, old, value);
	}

	public String[] getFieldNames() {
		return new String[] {"name", "author", "publisher", "publishDate", "price", "status", "abbr"};
	}

}
