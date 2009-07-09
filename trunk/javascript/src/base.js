
// wrapper a native generator and provide additional methods
function XGenerator(generator) {
	this.generator = generator;
}
XGenerator.prototype = {
	__iterator__: function(){
		return this.generator.__iterator__();
	},
	filter: function(func) {
		var g = this.generator;
		function inner(){
			for each(let item in g){
				if(func(item)) yield item;
			}
		}
		return new XGenerator(inner());
	},
	map: function(func){
		var g = this.generator;
		function inner(){
			for each(let item in g){
				yield func(item);
			}
		}
		return new XGenerator(inner());
	},
	forEach: function(func){
		var g = this.generator;
		for each(let item in g){
			func(item);
		}
	},
	every: function(func){
		var g = this.generator;
		for each(let item in g){
			if(!func(item)) return false;
		}
		return true;
	},
	some: function(func){
		var g = this.generator;
		for each(let item in g){
			if(func(item)) return true;
		}
		return false;
	},
	pipe: function(func){	// func(XGenerator)
		return func(this);
	}
}

XGenerator.prototype.foreach = XGenerator.prototype.forEach;

function notnull(it) { return it != null }


// return a XGenerator instead of native Generator
function fileReader(reader){

	importPackage(java.io);
	
	if(typeof reader == "object" && reader.valueOf != null)
		reader = reader.valueOf();
	
	if(typeof reader == "string") {
		reader = new File(reader);
	}
	if(reader instanceof File){
		reader = new FileInputStream(reader);
	}
	if(reader instanceof InputStream){
		reader = new InputStreamReader(reader);
	}
	if(reader instanceof Reader ){
		reader = new BufferedReader(reader);
	}
	
	if(!(reader instanceof BufferedReader))
		throw "invalid input, must be filename, or a File, InputStream, Reader object";
	
	function inner(){
		for(;;){
			var line = reader.readLine();
			if(line != null) 
				yield line;
			else
				break;
		}
	}
	
	return new XGenerator(inner());
}