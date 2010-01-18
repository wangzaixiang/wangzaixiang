/*
 * PointEditor.fx
 *
 * Created on Jan 18, 2010, 10:28:51 AM
 */

package wangzx.morphfx.shapes;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;

/**
 * 可视化的编辑 Line
 * 在 MorphEditor的基础之上再加上对终点的拖动
 */
public class PointEditor extends CustomNode {
    public var x: Number;
    public var y: Number;
    public var fill = Color.DARKGREEN;

    override function create(): Node {
        return Circle {
            centerX: bind x
            centerY: bind y
            radius: 5
            fill: this.fill
            opacity: 0.75

            var deltaX: Number;
            var deltaY: Number;
            onMousePressed: function(e){
                deltaX = x - e.sceneX;
                deltaY = y - e.sceneY;
            }
            onMouseDragged: function(e){
                x = e.sceneX + deltaX;
                y = e.sceneY + deltaY;
            }


        }

    }

}


