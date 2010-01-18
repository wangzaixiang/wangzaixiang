/*
 * LineEditor.fx
 *
 * Created on Jan 17, 2010, 1:45:57 PM
 */

package wangzx.morphfx.shapes;

import javafx.scene.shape.Line;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.Group;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.shape.Polyline;


public class LineEditor extends CustomNode {
    public-init var line: Line;

    override function create () : Node {
        def it = this.line;
        return Group {
            content: [
                PointEditor {
                    x: bind it.startX with inverse
                    y: bind it.startY with inverse
                }
                PointEditor {
                    x: bind it.endX with inverse
                    y: bind it.endY with inverse
                }
            ]
        }
    }
};


function run(){
        
Stage {
	title : "MyApp"
	scene: Scene {
		width: 200
		height: 200
                var line: Line;
                var polyline: Polyline;
		content: [
                    line = Line {
                            startX: 10 startY: 10
                            endX: 100 endY:100
                            strokeWidth: 5
                            // stroke: Color.BLACK
                        }               
                    LineEditor { line: line }
                ]
	}
}
}
