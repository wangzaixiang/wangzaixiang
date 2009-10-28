package wangzx.jdbc

import java.sql.{Connection, ResultSet, Statement, PreparedStatement, Date}
import scala.collection.mutable

/**
 *
 */
object RichSQL2 {

  /**
   * convert the current row of a ResultSet to an Map
   */
  private def resultSet2Map(rs:ResultSet): Map[String, Any] = {
    var map: mutable.Map[String, Any] = mutable.Map.empty
    val meta = rs.getMetaData
    for(val i <- 1 to meta.getColumnCount) {
      val columnName = meta.getColumnName(i)
      val columnValue = rs.getObject(i)
      map.put(columnName, columnValue)
    }
    Map.empty ++ map
  }

  // mapping resultset to an Scala Bean
  private def resultSet2Bean[X] (clazz: Class[X]) (rs:ResultSet): X = {
    val result = clazz.newInstance
    val meta = rs.getMetaData
    val methods = clazz.getMethods.filter {
      (m) => m.getName.endsWith("_$eq") && m.getParameterTypes.length == 1
    }
    val map: mutable.Map[String, java.lang.reflect.Method] = mutable.Map.empty
    for(val m <- methods){
      var name = m.getName.substring(0, m.getName.length-4);
      map.put(name.toUpperCase, m)
    }
    for(val i <- 1 to meta.getColumnCount){
      val name = meta.getColumnName(i);
      val method = map(name.toUpperCase)
      if(method != null) {
        val value = rs.getObject(i)
        method.invoke(result, value)
      }
    }
    result
  }

  private def resultSet2Stream[X](f: ResultSet=>X, rs:ResultSet): Stream[X] = {
    if(rs.next) Stream.cons( f(rs), resultSet2Stream(f, rs) )
    else {
      rs.close
      Stream.empty
    }
  }

  /**
   * check an un-scrolled ResultSet and return an Map(when only 1 row)
   * or null(for no row)
   */
  private def rs2map0_1(rs:ResultSet): Map[String,Any] = {
    if(rs.next){
      val result = resultSet2Map(rs);
      if(rs.next==false)  // just 1 row
        return result
      else  // more than one row
        throw new RuntimeException("Query expect 1 row but actually return more than 1 row")
    }
    else  // 0 row
      return null
  }

  /**
   * query0_1 with a parametered statement and parameter, return a Map
   */
  def query0_1(s: String, paras: Any*)(implicit conn: Connection): Map[String, Any] = {
    query0_1(resultSet2Map _, s, paras)(conn)
  }

  def query0_1[X](clazz:Class[X], s: String, paras: Any*)(implicit conn:Connection):X = {
    val f: (ResultSet=>X) = resultSet2Bean(clazz)
    query0_1(f, s, paras)(conn)
  }

  /**
   * query0_1 with a parametered statement and parameters, and an ObjectMapper, return an object or null
   */
  def query0_1[X](f: ResultSet=>X, s: String, paras: Any*)(implicit conn: Connection): X = {
    val stmt = conn.prepareStatement(s);
    val md = stmt.getParameterMetaData
    for(val i <- 1 to md.getParameterCount){
      stmt.setObject(i, paras(i-1))
    }

    val rs = stmt.executeQuery

    if(rs.next){
      if(rs.next==false)  // just 1 row
        return f(rs)
      else  // more than one row
        throw new RuntimeException("Query expect 1 row but actually return more than 1 row")
    }
    else  // 0 row
      return null.asInstanceOf[X]
  }

  // query0_1 with fixed statment, return a Map
  def query0_1(s: String)(implicit conn:Connection): Map[String, Any] = {
    query0_1(resultSet2Map _, s)(conn);
  }

  def query0_1[X](clazz: Class[X], s:String)(implicit conn: Connection): X = {
    val f: (ResultSet=>X) = resultSet2Bean(clazz)
    query0_1(f, s)(conn)
  }

  // query0_1 with fixed statement and Object Mapper, return Object
  def query0_1[X](f:ResultSet=>X, s:String)(implicit conn:Connection): X = {
    val stmt = conn.createStatement()
    val rs: ResultSet = stmt.executeQuery(s)

    if(rs.next){
      if(rs.next==false)  // just 1 row
        return f(rs)
      else  // more than one row
        throw new RuntimeException("Query expect 1 row but actually return more than 1 row")
    }
    else  // 0 row
      return null.asInstanceOf[X]
  }

  /* todo search NamedParameterStatement
   def query0_1(s: String, paras: Map[String, Any])(implicit conn: Connection): Map[String, Any] = {
   val stmt = conn.prepareStatement(s);
   val md = stmt.getParameterMetaData
   var i = 1
   while(i <= md.getParameterCount){
   val name = md.
   stmt.setObject(i, paras(i-1))
   }

   val rs = stmt.executeQuery
   return rs2map0_1(rs)

   }
   */

  /**
   * query with a parametered statement and parameter, return a Stream of Map
   */
  def query(s: String, paras: Any*)(implicit conn: Connection): Stream[Map[String, Any]] = {
    query(resultSet2Map _, s, paras)(conn)
  }

  def query[X](clazz:Class[X], s:String, paras: Any*)(implicit conn: Connection): Stream[X] = {
    val f: (ResultSet=>X) = resultSet2Bean(clazz)
    query(f, s, paras)(conn)
  }

    /**
   * query0_1 with a parametered statement and parameters, and an ObjectMapper, return an object or null
   */
  def query[X](f: ResultSet=>X, s: String, paras: Any*)(implicit conn: Connection): Stream[X] = {
    val stmt = conn.prepareStatement(s);
    val md = stmt.getParameterMetaData

    for(val i <- 1 to md.getParameterCount) {
      stmt.setObject(i, paras(i-1))
    }

    val rs = stmt.executeQuery
    return resultSet2Stream(f, rs)
  }

  // query0_1 with fixed statment, return a Map
  def query(s: String)(implicit conn:Connection): Stream[Map[String, Any]] = {
    query(resultSet2Map _, s)(conn);
  }

  def query[X](clazz: Class[X], s:String)(implicit conn: Connection): Stream[X] = {
    val f:(ResultSet=>X) = resultSet2Bean(clazz)
    query(f, s)(conn)
  }

    // query0_1 with fixed statement and Object Mapper, return Object
  def query[X](f:ResultSet=>X, s:String)(implicit conn:Connection): Stream[X] = {
    val stmt = conn.createStatement()
    val rs: ResultSet = stmt.executeQuery(s)

    resultSet2Stream(f, rs)
  }

    /**
   * query0_1 with a parametered statement and parameter, return a Map
   */
  def query1(s: String, paras: Any*)(implicit conn: Connection): Map[String, Any] = {
    query1(resultSet2Map _, s, paras)(conn)
  }

  def query1[X](clazz: Class[X], s: String, paras: Any*)(implicit conn: Connection): X = {
    val f: (ResultSet=>X) = resultSet2Bean(clazz)
    query1(f, s, paras)(conn)
  }

  /**
   * query0_1 with a parametered statement and parameters, and an ObjectMapper, return an object or null
   */
  def query1[X](f: ResultSet=>X, s: String, paras: Any*)(implicit conn: Connection): X = {

    val result = query0_1(f, s, paras)
    assert(result != null, "Query expect 1 row but returns 0 row")

    result
  }

  // query0_1 with fixed statment, return a Map
  def query1(s: String)(implicit conn:Connection): Map[String, Any] = {
    query1(resultSet2Map _, s)(conn);
  }

  def query1[X](clazz: Class[X], s: String)(implicit conn: Connection): X = {
    val f: (ResultSet=>X) = resultSet2Bean(clazz)
    query1(f, s)(conn)
  }

  // query0_1 with fixed statement and Object Mapper, return Object
  def query1[X](f:ResultSet=>X, s:String)(implicit conn:Connection): X = {
    val result = query0_1(f, s)(conn)
    assert(result != null, "Query expect 1 row but returns 0 row")

    result
  }

  def queryInt(s: String)(implicit conn: Connection): Int = {
    val stmt = conn.createStatement
    val rs = stmt.executeQuery(s)
    assert(rs.next, "queryInt return no row")
    return rs.getInt(1)  
  }

  def queryInt(s:String, para: Any*)(implicit conn: Connection): Int = {
    val stmt = conn.prepareStatement(s);
    for(val i<- 1 to para.size){
      stmt.setObject(i, para(i+1))
    }
    val rs = stmt.executeQuery
    assert(rs.next, "queryInt return no row")
    return rs.getInt(1);
  }

  def transaction(f: =>Unit)(implicit conn: Connection) {
    try {
      conn.setAutoCommit(false);
      f
      conn.commit
    } catch {
      case _ =>
        conn.rollback
    }
  }

  implicit def connection2Rich(conn: Connection) = new RichConnection(conn);
  implicit def statement2Rich(stmt: Statement) = new RichStatement(stmt);
  implicit def preparedStatement2Rich(ps: PreparedStatement) = new RichPreparedStatement(ps);

  class RichConnection(val conn: Connection) {
    def <<(sql: String) = new RichStatement(conn.createStatement) << sql;
    def <<(sql: Array[String]) = new RichStatement(conn.createStatement) << sql;
  }

  class RichStatement(val stmt: Statement) {
    def <<(sql: String) = { stmt.execute(sql); this }
    def <<(sql: Array[String]) = {
      for(val str <- sql) stmt.execute(str)
      this
    }
  }

  class RichPreparedStatement(val ps: PreparedStatement) {
    var pos = 1;

    private def inc = {pos = pos + 1; this}

    def execute = { pos = 1; ps.execute }
    def <<! = execute;

    def <<(b: Boolean) = { ps.setBoolean(pos, b); inc }
    def <<(x: Byte) = { ps.setByte(pos, x); inc }
    def <<(i: Int) = { ps.setInt(pos, i); inc }
    def <<(x: Long) = { ps.setLong(pos, x); inc }
    def <<(f: Float) = { ps.setFloat(pos, f); inc }
    def <<(d: Double) = { ps.setDouble(pos, d); inc }
    def <<(o: String) = { ps.setString(pos, o); inc }
    def <<(x: Date) = { ps.setDate(pos, x); inc }


  }

}
