// Module for database access

// load module config from demo/db.cfg in JSON format
// driver/url/username/password

// start is invoked when module startup
function init() {
	var config = context.config(); // load config 
	print("url = " + config.url);
}

/**
 * insert into table with map
 * if the PK field have no value, it will auto generated and returned
 */
function insert(table, object){

}

/**
 * update the table with map(be sure the PK field have value, otherwise
 * a exception will be throwed)
 */
function update(table, object){

}

function delete(table, object){
}

/**
 * eg. query("select * from table1 where name = :name and value = :value",
 	{name: 'Some', value: 'Others'} );
 */
function query(statement, parameters){
}