/**
 * 这个脚本分析TransHandler.log，对其中所有未完成处理的交易进行分析，产生报告。
 * 主要目的：
 * 当系统出现故障时，会导致很多的交易未能完成正确处理过程，而停留在处理中间，本程序
 * 通过分析日志，找出所有未完成的交易，并显示该笔交易的最后处理环境，以帮助进行定位
 */
load("base.js");

// extract a matched line's [line, transactionId, information]
function extract(line){	
	var re = /^\[[\d\s:\-]+\] DEBUG *(\[[\d\s:\.\-\[\]]*\])(.*)$/;
	return re.exec(line);
}

function cat(input) {	input.foreach(print); 	}

// parse input(a XGenerator) and output parse result
function parse(input){
	
	var map = {};	// id -> [firstInfo, lastInfo]

	input.map(extract).filter(notnull).foreach( function(it) {
			let [, id, info] = it;
			if( /开始处理.*/.test(info) ){	// 在map中记录一个开始项
				map[id] = [info, info];
			}
			else if( /完成交易.*/.test(info) ){	// 交易已完成，清除记录
				delete map[id];
			}
			else if(map[id] != null){	// 更新交易的最后处理信息
				map[id][1] = info;
			}
		} );
	
	function inner(){
		yield "所有未处理完成的交易:";
		for(let id in map) {
			let [first, last] = map[id];
			yield id + "\t" + first + "\t" + last;
		}
	}
	return new XGenerator(inner());
}

function main(file){
	if(file == null){
		file = java.lang.System["in"];
	}
	
	var reader = fileReader(file);	

	reader.pipe(parse).pipe(cat);
}
