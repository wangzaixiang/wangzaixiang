package com.google.gwt.uibinder.elementparsers;


public class BindBuilder {

	PathBuilder path1, path2;

	public PathBuilder getPath1() {
		return path1;
	}

	public void setPath1(PathBuilder path1) {
		this.path1 = path1;
	}

	public PathBuilder getPath2() {
		return path2;
	}

	public void setPath2(PathBuilder path2) {
		this.path2 = path2;
	}
	
	public BindBuilder(PathBuilder path1, PathBuilder path2){
		this.path1 = path1;
		this.path2 = path2;	
		if(path1.valueType != path2.valueType){
			throw new RuntimeException("bind incompatible type of" + path1.valueType + "<->" + path2.valueType);
		}
	}
	
	public String toSource(){
		return String.format("addBinding(%s, %s);", path1.toSource(), path2.toSource());
	}


}
