/*
 * PolylineEditor2.fx
 *
 * Created on Jan 18, 2010, 10:32:43 AM
 */
package wangzx.morphfx.shapes;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.shape.Polyline;
import javafx.scene.paint.Color;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.Group;
import java.lang.System;
import java.lang.Math;
import javafx.scene.shape.Circle;

class PointEditor extends CustomNode {
    var x: Number;
    var y: Number;
    var isMiddle: Boolean = false;   // a middle point does not exists in polyline.points

    var fill = bind if(isMiddle) Color.LIGHTGRAY else Color.DARKGREEN;

    var onPointChange: function(PointEditor):Void;
    var afterPointChange: function(PointEditor):Void;

    override function create(): Node {
        return Circle {
            centerX: bind x
            centerY: bind y
            radius: 5
            fill: bind this.fill
            opacity: 0.75

            var deltaX: Number;
            var deltaY: Number;
            var changed = false;
            onMousePressed: function(e){
                deltaX = x - e.sceneX;
                deltaY = y - e.sceneY;
            }
            onMouseDragged: function(e){
                changed = true;
                x = e.sceneX + deltaX;
                y = e.sceneY + deltaY;
                if(onPointChange != null)
                    onPointChange(this);
            }
            onMouseReleased: function(e){
                if(changed and afterPointChange!= null){
                    afterPointChange(this);
                    changed = false;
                }
            }

        }
    }
}


/**
 * @author 王在祥
 */
/* place your code here
class Point {
    var x: Number on replace o = n {
        System.out.println("({o},{y}) => ({n},{y} onChange= {onChange})");
        if(onChange != null) onChange(this);
    }

    var y: Number on replace o = n {
        System.out.println("({x},{o}) => ({x},{n}) onChange= {onChange}");
        if(onChange != null) onChange(this);
    }

    var isMiddle = false;
    var previous: Point;
    var next: Point;
    
    var onChange: function(p: Point):Void;
} */

public class PolylineEditor2 extends CustomNode {

    public-init var polyline: Polyline;
    def onPointChange: function(PointEditor):Void = function(point){
        // polyline.points = for(point in points) [point.x, point.y];
        if(point.isMiddle) {  // convert
            point.isMiddle = false;
        }
        else { // drag a vertex should update middles
            checkMiddlePoints(points);
            points = addMiddlePoints(points);
            for(p1 in points where p1.onPointChange == null)
                p1.onPointChange = onPointChange;
        }
        polyline.points = for(p in points where p.isMiddle == false) [p.x, p.y];

        System.out.println("points now: {polyline.points}");
    }

    //
    var points: PointEditor[] = initPoints();
    // var middles: Point[] = bind middlePoints(points);


    function initPoints(){

        var i  = 0;
        var points: PointEditor[] = [];
        while(i < sizeof polyline.points) {
            insert PointEditor {
                x: polyline.points[i]
                y: polyline.points[i+1]
                onPointChange: onPointChange
            } into points;
            i = i + 2;
        }

        points = addMiddlePoints(points);
        return points;
    }

    function isLine(p1: PointEditor, p2: PointEditor, p3: PointEditor): Boolean {

        if(p2.x == p1.x)
            return p3.x == p1.x;

        var angle = (p2.y  - p1.y) / (p2.x - p1.x);
        if(p3.x == p1.x) return false;
        var angle2 = (p3.y - p1.y) / (p3.x - p1.x);

        return Math.abs(angle - angle2) < 0.01;
    }


    // find middle points and remove it from vertex
    function checkMiddlePoints(points: PointEditor[]): PointEditor[] {
        var index = 1;
        var vertexs = points[x | x.isMiddle==false];

        while(index+1 < sizeof vertexs) {
            if(isLine(vertexs[index-1], vertexs[index], vertexs[index+1])){
                vertexs[index].isMiddle = true;
            }
            index++;
        }

        return vertexs;
    }


    function addMiddlePoints(points: PointEditor[]): PointEditor[] {
        var pos = 0;
        var vertexs = points[x | x.isMiddle == false];
        var result = vertexs;
     
        //var middles: Point[] = [];
        while(pos < sizeof(result)){
            if(pos+2 < sizeof result){ // here next next2
                var x1 = (result[pos].x + result[pos+2].x)/2;
                var y1 = (result[pos].y + result[pos+2].y)/2;
                var dis = Math.pow(x1 - result[pos+1].x, 2) + Math.pow(y1 - result[pos+1].y, 2);
                if(dis < 1){ // smaller: next is the middle, dont add mid-point between pos and next2
                    pos = pos + 2;
                    continue;
                }
                else { // add a middle
                    x1 = (result[pos].x + result[pos+1].x)/2;
                    y1 = (result[pos].y + result[pos+1].y)/2;
                    insert PointEditor {
                            x: x1
                            y: y1
                            isMiddle: true
                            //fill: Color.LIGHTPINK
                            //previous: result[pos]
                            //next: result[pos+1]
                            onPointChange: onPointChange
                    } before result[pos+1];
                    pos = pos+1+1;
                    continue;
                }
            }
            else if(pos + 1 < sizeof result) { // here next
                // add mid between pos and next
                var x1 = (result[pos].x + result[pos+1].x)/2;
                var y1 = (result[pos].y + result[pos+1].y)/2;
                insert PointEditor {
                        x: x1
                        y: y1
                        isMiddle: true
                        //fill: Color.LIGHTPINK
                        //previous: result[pos]
                        //next: result[pos+1]
                        onPointChange: onPointChange
                } before result[pos+1];
                pos = pos + 2;
                continue;
            }
            else { // the last node
                break;
            }
        }
        return result;

    }


    override function create () : Node {
        return Group {
            content: bind points
        }
    }

    /*function pointEditor4(p: Point) {
        def it = p;
        return PointEditor {
            x: bind it.x with inverse
            y: bind it.y with inverse
        }
    }*/

    /*
    function addMiddlePoints(old: PointEditor[], onChange: function(PointEditor):Void): PointEditor[] {
        var pos = 0;
        var result = old;
        //var middles: Point[] = [];
        while(pos < sizeof(result)){
            if(pos+2 < sizeof result){ // here next next2
                var x1 = (result[pos].x + result[pos+2].x)/2;
                var y1 = (result[pos].y + result[pos+2].y)/2;
                var dis = Math.pow(x1 - result[pos+1].x, 2) + Math.pow(y1 - result[pos+1].y, 2);
                if(dis < 1){ // smaller: next is the middle, dont add mid-point between pos and next2
                    pos = pos + 2;
                    continue;
                }
                else { // add a middle
                    x1 = (result[pos].x + result[pos+1].x)/2;
                    y1 = (result[pos].y + result[pos+1].y)/2;
                    insert PointEditor {
                            x: x1
                            y: y1
                            isMiddle: true
                            //previous: result[pos]
                            //next: result[pos+1]
                            onPointChange: onChange
                    } before result[pos+1];
                    pos = pos+1+1;
                    continue;
                }
            }
            else if(pos + 1 < sizeof result) { // here next
                // add mid between pos and next
                var x1 = (result[pos].x + result[pos+1].x)/2;
                var y1 = (result[pos].y + result[pos+1].y)/2;
                insert PointEditor {
                        x: x1
                        y: y1
                        isMiddle: true
                        //previous: result[pos]
                        //next: result[pos+1]
                        onPointChange: onChange
                } before result[pos+1];
                pos = pos + 2;
                continue;
            }
            else { // the last node
                break;
            }
        }
        return result;
    }
    */
}


function run() {
    Stage {
        title: "MyApp"
        scene: Scene {
            width: 400
            height: 400
            
            var polyline: Polyline;
            content: [
                polyline = Polyline {
                    points: [10.0, 45.0,
                        55.0, 45.0,
                        50.0, 20.0,
                        92.0, 50.0,
                        50.0, 80.0,
                        55.0, 55.0,
                        10.0, 55.0]
                    stroke: Color.RED
                    fill: Color.FORESTGREEN
                    // scaleX: 3
                    // scaleY: 3
                }
                PolylineEditor2 { polyline: polyline }
            ]
        }
    }
}
