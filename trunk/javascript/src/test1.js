
function sums(n){
	var sum = 0;
	for(var i=0; i<=n; i++) {
		sum = sum + i;
		yield sum;
	}
}

function identify(item){
	return item;
}

function xsums(n){
	return new XGenerator(sums(n));
}