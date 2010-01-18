/*
 * MouselessControlWrap.fx
 *
 * Created on Jan 17, 2010, 1:28:57 PM
 */

package wangzx.morphfx;

import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import java.lang.System;

public class MouselessControlWrap extends Group {

    public-init var node: Node;

    override def content = bind [
        node,
        Rectangle {
                x: bind node.layoutBounds.minX
                y: bind node.layoutBounds.minY
                width: bind node.layoutBounds.width
                height: bind node.layoutBounds.height
                fill: Color.TRANSPARENT
                blocksMouse: true
                onMousePressed: function(e):Void {
                    System.out.println('this = {this} e.node = {e.node} {this.onMousePressed} - {e.node.onMousePressed}');

                    // TODO it looks there is a bug for call this.onMousePressed
                    var it: Node = null;
                    it = this;

                    if(it.onMousePressed != null)
                        it.onMousePressed(e);
                }
        }

    ]

}

