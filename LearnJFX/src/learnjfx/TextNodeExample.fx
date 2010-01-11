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

/**
 * @author 王在祥
 */
// place your code here
def text = Text {
            font: Font {
                size: 24
            }
            translateX: 10 translateY: 30
            // x: 10, y: 30
            content: "HelloWorld"
        };

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

Stage {
    title: "MyApp"
    scene: Scene {
        width: 600
        height: 480
        content: [
            Rectangle {
                x: bind text.boundsInParent.minX,
                y: bind text.boundsInParent.minY
                width: bind text.boundsInParent.width
                height: bind text.boundsInParent.height
                strokeWidth: 1
                opacity: 0.2
            }
            
            text,

            
            VBox {
                translateY: 300 translateX: 10
                content: [
                    
                    FloatItem {
                        label: "x:"
                        max: 600
                        value: bind text.translateX with inverse;
                    },
                    FloatItem {
                        label: "y:" max: 480
                        value: bind text.translateY with inverse
                    },
                    FloatItem {
                        label: "rotate"
                        max: 360
                        value: bind text.rotate with inverse
                    }
                    FloatItem {
                        label: "scalaX"
                        max: 5
                        value: bind text.scaleX with inverse
                    }
                    FloatItem {
                        label: "scalaY"
                        max: 5
                        value: bind text.scaleY with inverse
                    }
                    FloatItem {
                        label: "opacity"
                        max: 1.0
                        value: bind text.opacity with inverse
                    }
                    FloatItem {
                        label: "layoutX"
                        value: bind text.layoutX with inverse
                    }
                    FloatItem {
                        label: "layoutY"
                        value: bind text.layoutY with inverse
                    }
                ]
            }
        ]
    }
}
