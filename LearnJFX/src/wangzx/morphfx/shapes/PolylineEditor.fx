/*
 * PolylineEditor.fx
 *
 * Created on Jan 18, 2010, 10:27:39 AM
 */

package wangzx.morphfx.shapes;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Polyline;
import javafx.util.Math;
import javafx.scene.paint.Color;


class PolylinePoint1 {
    public-init var polyline: Polyline;
    public-init var index: Integer;

    var x: Number = polyline.points[2*index] on replace o = n {
            polyline.points[2*index] = n;
    };
    var y: Number = polyline.points[2*index+1] on replace o = n {
        polyline.points[2*index+1] = n;
    }
}
// used to create a new line
class PolylinePoint2 extends Circle {
    public-init var polyline: Polyline;
    public-init var index: Integer;

    override def radius = 8;
    override def fill = Color.LIGHTPINK;


    var deltaX: Number;
    var deltaY: Number;
    var inserted = false;

    override def onMousePressed = function(e){
        deltaX = centerX - e.sceneX;
        deltaY = centerY - e.sceneY;
    };
    override def onMouseDragged = function(e){
        centerX = e.sceneX + deltaX;
        centerY = e.sceneY + deltaY;
        if(inserted == false){
            // index, next
            insert [centerX, centerY] before polyline.points[index+2];
            inserted = true

        }
        else {
            polyline.points[index+2] = centerX;
            polyline.points[index+3] = centerY;
        }


   };
}


public class PolylineEditor extends CustomNode{

    public-init var polyline: Polyline;

    override function create(): Node {

        var node = Group {
            content: bind [ point1(polyline.points), point2(polyline.points) ];
        }

        return node
    }

    function point1(points: Number[]): Node[] {
        var i = 0;
        var editors: PointEditor[];
        while(i<sizeof polyline.points){

            def point = PolylinePoint1 {
                polyline: polyline
                index: i/2
            };

            insert PointEditor {
                x: bind point.x with inverse
                y: bind point.y with inverse
            } into editors;

            i = i + 2;
        }
        return editors;
    }

    function point2(points: Number[]): Node[] {
        var added: Circle[] = [];
        var pos = 0;
        while(pos < sizeof(polyline.points)){
            if(pos+4 < sizeof polyline.points){ // therefor here next next2
                var next = pos + 2;
                var next2 = pos + 4;
                var x1 = (polyline.points[pos] + polyline.points[next2])/2;
                var y1 = (polyline.points[pos+1] + polyline.points[next2+1])/2;
                var dis = Math.pow(x1 - polyline.points[next], 2) + Math.pow(y1 - polyline.points[next+1], 2);
                if(dis < 1){
                    // next is the middle, dont add mid-point between pos and next2
                    pos = next2;
                    continue;
                }
                else {
                    // add mid between pos and next
                    x1 = (polyline.points[pos] + polyline.points[next])/2;
                    y1 = (polyline.points[pos+1] + polyline.points[next+1])/2;
                    insert PolylinePoint2 {
                        polyline: polyline
                        index: pos
                        centerX: x1
                        centerY: y1
                    } into added;
                    pos = next;
                    continue;
                }
            }
            else if(pos + 2 < sizeof polyline.points) { // here next
                // add mid between pos and next
                var next = pos + 2;
                var x1 = (polyline.points[pos] + polyline.points[next])/2;
                var y1 = (polyline.points[pos+1] + polyline.points[next+1])/2;
                insert PolylinePoint2 {
                        polyline: polyline
                        index: pos
                        centerX: x1
                        centerY: y1
                } into added;
                pos = next;
                continue;
            }
            else { // the last node
                break;
            }

        }
        return added;

    }

    function create0(): Node {

        // prepare();

        var editors: PointEditor[] = [];
        var i = 0;
        while(i<sizeof polyline.points){

            def point = PolylinePoint1 {
                polyline: polyline
                index: i/2
            };

            insert PointEditor {
                x: bind point.x with inverse
                y: bind point.y with inverse
            } into editors;

            i = i + 2;
        }

        // var added = addNew();

        //return Group {
        //    content: [ editors, added ]
        // }
        return null
    }


}
