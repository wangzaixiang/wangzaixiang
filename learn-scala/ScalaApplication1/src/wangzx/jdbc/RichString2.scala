/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package wangzx.jdbc

object RichString2 {

   implicit def StringToRichString2(s: String): RichString2 =
     new RichString2(s)

}

class RichString2(str: String) {

  def ==?(other: String): Boolean = {
    if(str == null || str == "")
      return (other == null) || (other == "")

    return str == other
  }

  def !=?(other: String): Boolean = {
    return !(this ==? other)
  }
  
}
