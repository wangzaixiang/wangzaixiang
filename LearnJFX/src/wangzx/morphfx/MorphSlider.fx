/*
 * MorphSlider.fx
 *
 * Created on Jan 17, 2010, 1:26:16 PM
 */

package wangzx.morphfx;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Panel;
import javafx.scene.layout.VBox;

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
};

public class MorphSlider extends Panel {

    public-init var root: MorphWorkspace;

    def morphContainer = bind root.morphContainer;

    override def content = bind createForMorph(root.morphContainer.selected);

    function createForMorph(morph: Node): Node {
        def it = morph;
        return if(visible==false or it==null) null else VBox {
        translateY: 300 translateX: 10
        content: [
            FloatItem {
                label: "x:"
                max: bind root.width
                value: bind it.translateX with inverse;
            },
            FloatItem {
                label: "y:" max: bind root.height
                value: bind it.translateY with inverse
            },
            FloatItem {
                label: "rotate"
                max: 360
                value: bind it.rotate with inverse
            }
            FloatItem {
                label: "scalaX"
                max: 5
                value: bind it.scaleX with inverse
            }
            FloatItem {
                label: "scalaY"
                max: 5
                value: bind it.scaleY with inverse
            }
            FloatItem {
                label: "opacity"
                max: 1.0
                value: bind it.opacity with inverse
            }
        ]
        };

    }

}
