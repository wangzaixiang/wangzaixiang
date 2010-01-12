/*
 * TextNodeExample.fx
 *
 * Created on Jan 11, 2010, 9:59:35 PM
 */
package learnjfx;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;
import javafx.scene.text.Font;
import javafx.scene.control.Slider;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.layout.VBox;
import javafx.scene.shape.Rectangle;
import javafx.scene.input.MouseEvent;
import java.lang.System;
import javafx.scene.Group;
import javafx.scene.shape.Circle;
import javafx.scene.paint.Color;
import javafx.scene.control.Button;
import java.lang.Math;

/**
 * @author 王在祥
 */
// place your code here
def textNode = Text {
            font: Font {
                size: 24
            }
            translateX: 50 translateY: 50
            // x: 10, y: 30
            content: "HelloWorld"
        };

def node2 = Rectangle {
	x: 100, y: 100
	width: 140, height: 90
	fill: Color.RED
}

def node2Outline = MorphOutline {
    node: node2
}



/*
def outline = Rectangle {
            translateX: bind text.boundsInParent.minX,
            translateY: bind text.boundsInParent.minY
            //x: bind text.boundsInParent.minX,
            //y: bind text.boundsInParent.minY
            width: bind text.boundsInParent.width
            height: bind text.boundsInParent.height
            strokeWidth: 1
            opacity: 0.2
              
            var deltaX = 0.0;
            var deltaY = 0.0;
            
            onMousePressed: function (e:  MouseEvent): Void {
                deltaX = text.translateX - e.sceneX;
                deltaY = text.translateY - e.sceneY;
            }

            onMouseDragged: function (e: MouseEvent): Void {
                System.out.println("x = {e.x} y = {e.y}");
                text.translateX = e.sceneX + deltaX;
                text.translateY = e.sceneY + deltaY;
            }
        };
*/
/*
 rotate node: Drag it to rotate
 scala node: drag it to scala
 */
class MorphOutline extends CustomNode {

    public-init var node: Node;

    override function create(): Node {
        return Group {
            // translateX: bind text.boundsInParent.minX
            // translateY: bind text.boundsI
            translateX: bind node.boundsInParent.minX + node.boundsInParent.width / 2
            translateY: bind node.boundsInParent.minY + node.boundsInParent.height / 2

            content: [
                Rectangle {  // bounds in parent, shadow, movable
                    translateX: bind -node.boundsInParent.width / 2
                    translateY: bind -node.boundsInParent.height / 2
                    width: bind node.boundsInParent.width
                    height: bind node.boundsInParent.height
                    strokeWidth: 1
                    opacity: 0.2
                    
                    var deltaX = 0.0;
                    var deltaY = 0.0;
                    onMousePressed: function (e:  MouseEvent): Void {
                        deltaX = node.translateX - e.sceneX;
                        deltaY = node.translateY - e.sceneY;
                    }

                    onMouseDragged: function (e: MouseEvent): Void {
                        // System.out.println("x = {e.x} y = {e.y}");
                        node.translateX = e.sceneX + deltaX;
                        node.translateY = e.sceneY + deltaY;
                    }
                }
                /*Circle { // Left-Top
                    centerX: bind -text.boundsInParent.width / 2 - 6
                    centerY: bind -text.boundsInParent.height / 2 - 6
                    radius: 6
                }*/
                Circle {    // Top - Center, scalaY
                    centerX: 0
                    centerY: bind -node.boundsInParent.height / 2 - 6
                    radius: 6
                    fill: Color.BLUE

                    var baseX = 0.0
                    var baseY = 0.0
                    var baseWidth = 0.0
                    var baseHeight = 0.0
                    onMousePressed: function (e:  MouseEvent): Void {
                        baseWidth = node.boundsInParent.width;
                        baseHeight = node.boundsInParent.height;
                        baseX = e.sceneX;
                        baseY = e.sceneY;
                    }

                    onMouseDragged: function (e: MouseEvent): Void {
                        //var scalaX = (baseWidth + 2 * (e.sceneX - baseX)) / text.boundsInParent.width;
                        var scalaY = (baseHeight + 2 * (- e.sceneY + baseY)) / node.boundsInParent.height;
                        //text.scaleX = text.scaleX * scalaX;
                        node.scaleY = node.scaleY * scalaY;
                    }
                }
                /*
                Circle { // Right-Top
                    centerX: bind text.boundsInParent.width / 2 + 6,
                    centerY: bind -text.boundsInParent.height / 2 - 6
                    radius: 6 
                }*/
                Circle { // Left - Center, rotate
                    // (cos(angle), sin(angle))
                    var r = bind Math.sqrt(Math.pow(node.boundsInParent.width/2, 2) +
                        Math.pow(node.boundsInParent.height/2, 2)) + 20;
                    centerX: bind r * Math.cos(node.rotate / 180 * Math.PI)
                    centerY: bind r * Math.sin(node.rotate / 180 * Math.PI)

                    fill: Color.GREEN
                    radius: 6

                    var baseX = 0.0
                    var baseY = 0.0
                    var baseWidth = 0.0
                    var baseHeight = 0.0
                    onMousePressed: function (e:  MouseEvent): Void {
                        baseX = e.sceneX;
                        baseY = e.sceneY;
                        baseWidth = node.boundsInParent.width;
                        baseHeight = node.boundsInParent.height;
                        baseX = e.sceneX;
                        baseY = e.sceneY;
                    }

                    onMouseDragged: function (e: MouseEvent): Void {
                        // angle =
                        // center: ()
                        if(e.x == 0 and e.y > 0){
                            node.rotate = 90
                        }
                        else if(e.x == 0 and e.y < 0) {
                            node.rotate = 270
                        }
                        else if(e.x > 0 and e.y == 0) {
                            node.rotate = 0
                        }
                        else if(e.x < 0 and e.y == 0) {
                            node.rotate = 180
                        }
                        else {
                            var tag = e.y / e.x;
                            var angle = Math.atan(tag) / Math.PI * 180;
                            if(e.y >0 and e.x>0) {
                                node.rotate = angle;
                            }
                            else if(e.y > 0 and e.x < 0) {
                                node.rotate = 180 + angle;
                            }
                            else if(e.y < 0 and e.x > 0) {
                                node.rotate = 360 + angle
                            }
                            else if(e.y < 0 and e.x < 0) {
                                node.rotate = 180 + angle
                            }

                            System.out.println("{e.y}/{e.x} = {angle}");
                        }

                    }

                }
                Circle {  // right-center scalaX
                    centerX: bind node.boundsInParent.width / 2 + 6
                    centerY: 0
                    radius: 6
                    fill: Color.BLUE

                    var baseX = 0.0
                    var baseY = 0.0
                    var baseWidth = 0.0
                    var baseHeight = 0.0
                    onMousePressed: function (e:  MouseEvent): Void {
                        baseWidth = node.boundsInParent.width;
                        baseHeight = node.boundsInParent.height;
                        baseX = e.sceneX;
                        baseY = e.sceneY;
                    }

                    onMouseDragged: function (e: MouseEvent): Void {
                        var scalaX = (baseWidth + 2 * (e.sceneX - baseX)) / node.boundsInParent.width;
                        //var scalaY = (baseHeight + 2 * (- e.sceneY + baseY)) / text.boundsInParent.height;
                        node.scaleX = node.scaleX * scalaX;
                        // text.scaleY = text.scaleY * scalaY;
                    }
                }/*
                Circle { // Left - Bottom
                    centerX: bind -text.boundsInParent.width / 2 - 6
                    centerY: bind text.boundsInParent.height / 2 + 6
                    radius: 6
                }
                Circle {    // Bottom - Center
                    centerX: 0
                    centerY: bind text.boundsInParent.height / 2 + 6
                    radius: 6
                }
                Circle {    // Right - Bottom
                    centerX: bind text.boundsInParent.width / 2 + 6
                    centerY: bind text.boundsInParent.height /2  + 6
                    radius: 6
                }*/
               

                ]
            };

         }

}

class FloatItem extends CustomNode {

    var label: String;
    var value: Float;
    var min: Float = 0;
    var max: Float = 100;

    override function create(): Node {
        return HBox {
                    spacing: 10
                    content: [
                        Label {
                            text: label
                        }
                        Slider {
                            min: min
                            max: max
                            vertical: false
                            value: bind value with inverse;
                        }
                    ]
                }
    }
}

def outline = MorphOutline {
    node: textNode
}


Stage {
    title: "MyApp"
    scene: Scene {
        width: 600
        height: 480
        content: [
            outline,
            textNode,
            node2,
            node2Outline,
            Button {
                text: "Debug"
                translateX: 200 translateY: 50
                action: function() {
                    debug();
                }
            }

            VBox {
                translateY: 300 translateX: 10
                content: [
                    FloatItem {
                        label: "x:"
                        max: 600
                        value: bind textNode.translateX with inverse;
                    },
                    FloatItem {
                        label: "y:" max: 480
                        value: bind textNode.translateY with inverse
                    },
                    FloatItem {
                        label: "rotate"
                        max: 360
                        value: bind textNode.rotate with inverse
                    }
                    FloatItem {
                        label: "scalaX"
                        max: 5
                        value: bind textNode.scaleX with inverse
                    }
                    FloatItem {
                        label: "scalaY"
                        max: 5
                        value: bind textNode.scaleY with inverse
                    }
                    FloatItem {
                        label: "opacity"
                        max: 1.0
                        value: bind textNode.opacity with inverse
                    }
                    FloatItem {
                        label: "layoutX"
                        value: bind textNode.layoutX with inverse
                    }
                    FloatItem {
                        label: "layoutY"
                        value: bind textNode.layoutY with inverse
                    }
                ]
            }
        ]
    }
}

function debug(){
    System.out.println("boundsInParent outline = {outline.boundsInParent} \n text = {textNode.boundsInParent}\n");
    System.out.println("boundsInLocal outline = {outline.boundsInLocal} \n text = {textNode.boundsInLocal}")
}
