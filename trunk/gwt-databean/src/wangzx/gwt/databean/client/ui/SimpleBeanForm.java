package wangzx.gwt.databean.client.ui;

import wangzx.gwt.databean.client.model.BeanReflection;

import com.google.gwt.user.client.ui.SimplePanel;

/**
 * 
 * <code>
 * | label1 | input1 | label2 | input2 |
 * | label3 | input3 | label4 | input4 |
 * == Category A ==
 * | label5 | input 5 |
 * == Category B == 
 * | label 6 | input 6 |
 * </code>
 * 
 * for textarea, it spans for a single row by default but can 
 * set by setFieldSpans
 * 
 * support for attribute categories by default.
 * 
 * support display/edit mode, default in edit mode
 * 
 */

public class SimpleBeanForm extends SimplePanel {

	private int gridColumns;

	public SimpleBeanForm(BeanReflection bean) {
		
		String[] fields = bean.getFieldNames();
		
		// first render all fields without category
		// in the order
		int row = 0;
		int column = 0;
		for(String field: fields){
			
			// check if needed to switch row
			if(column == gridColumns) {
				row++;
				column = 0;
			}
			int columnSpans = 1;	// retrieve columnSpans, max to gridColumns
			if(column + columnSpans > gridColumns){
				row++;
				column = 0;
			}
			// add Label, show icon, label and required mask
			// add the input widget, textarea default to span the whole row
			
		}
		
		// then for fields with category
		//
	}
	
	public SimpleBeanForm setGridColumns(int gridColumns){
		this.gridColumns = gridColumns;
		return this;
	}
	
	/**
	 * set field display order
	 */
	public SimpleBeanForm setFieldOrder(String ... fields){
		return this;
	}
	
	public SimpleBeanForm setCategoryOrder(String ...categories){
		return this;
	}
	
	public SimpleBeanForm setFieldSpans(String field, int columns){
		return this;
	}
	
	

}
