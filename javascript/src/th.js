/**
 * ����ű�����TransHandler.log������������δ��ɴ���Ľ��׽��з������������档
 * ��ҪĿ�ģ�
 * ��ϵͳ���ֹ���ʱ���ᵼ�ºܶ�Ľ���δ�������ȷ������̣���ͣ���ڴ����м䣬������
 * ͨ��������־���ҳ�����δ��ɵĽ��ף�����ʾ�ñʽ��׵�����������԰������ж�λ
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
			if( /��ʼ����.*/.test(info) ){	// ��map�м�¼һ����ʼ��
				map[id] = [info, info];
			}
			else if( /��ɽ���.*/.test(info) ){	// ��������ɣ������¼
				delete map[id];
			}
			else if(map[id] != null){	// ���½��׵��������Ϣ
				map[id][1] = info;
			}
		} );
	
	function inner(){
		yield "����δ������ɵĽ���:";
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
