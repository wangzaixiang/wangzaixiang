/*
 * MorphOutline.fx
 *
 * Created on Jan 17, 2010, 1:27:34 PM
 */

package wangzx.morphfx;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import java.lang.Math;
import javafx.scene.shape.Circle;


/**
 * 常规的Morph编辑器，对所有的Morph均有效。
 */

public class MorphEditor extends CustomNode {

    public-init var node: Node;

    override def blocksMouse = true;

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

