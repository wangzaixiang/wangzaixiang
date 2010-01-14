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
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Polyline;
import javafx.scene.control.Control;
import javafx.scene.control.TextBox;
import javafx.scene.input.MouseButton;
import javafx.scene.layout.Panel;
import javax.swing.JPopupMenu;
import javax.swing.JMenuItem;
import javafx.ext.swing.SwingComponent;
import javax.swing.JLabel;
import javax.swing.JRadioButtonMenuItem;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javafx.scene.control.CheckBox;
import javax.swing.JMenu;
import javafx.scene.control.ListView;
import javafx.scene.control.ProgressBar;
import javafx.scene.control.ProgressIndicator;
import javafx.scene.control.RadioButton;
import javafx.scene.control.ScrollBar;
import javafx.scene.control.ToggleButton;
import javafx.scene.control.Hyperlink;
import java.lang.RuntimeException;

/**
 * @author 王在祥
 */
// place your code here
def textNode = Text {
            font: Font {
                size: 24
            }
            translateX: 50 translateY: 250
            content: "HelloWorld"
        };

def rectNode = Rectangle {
	translateX: 150, translateY: 100
	width: 140, height: 90
	fill: Color.RED
}

var polygonNode = Polygon {
	points : [ 0,0, 100,0, 100,100 ]
	fill: Color.YELLOW
        translateX: 200
};

var textBox = TextBox {
	text: "SampleText"
	columns: 12
	selectOnFocus: true
        translateY: 150
};


var btnNode = Button {
    text: "确认"
    font: Font { name: "幼圆" size: 24 }
    translateX: 120
}

class MouselessControlWrap extends Group {

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


class MorphOutline extends CustomNode {

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

//def outline = MorphOutline {
//    node: textNode
//}

var polyLine = Polyline {
    points: [
        10.0, 45.0,
        55.0, 45.0,
        50.0, 20.0,
        92.0, 50.0,
        50.0, 80.0,
        55.0, 55.0,
        10.0, 55.0,
        10.0, 45.0
    ]
    stroke:Color.DARKGREEN;
    strokeWidth:2
    fill:Color.FORESTGREEN;
}

class MorphContainer extends Group {

    public-init var root: MorphFxPanel;
    // the Morph Control Pad

    //var outline: MorphOutline; // child of root
    public-read var selected: Node;

    function selectNode(node: Node) {
        System.out.println("select Node {node}");
        selected = node;
        root.morphOutline = if(node==null) null else MorphOutline {
            node: node
        }
    }

    var morphMousePressed = function(e: MouseEvent) {

    }


    override var content on replace oldValue[firstIndex .. lastIndex] = newValue {
        // add event for each morph
        for(node in content) {
            node.blocksMouse = true; //
            if(node.onMousePressed == null and not (node instanceof MorphOutline))
                node.onMousePressed = function(e: MouseEvent) {
                    // check e.node
                    var morph: Node = e.node;
                    while(morph != null and morph.parent != this) {
                        morph = morph.parent;
                    }

                    if(morph == null) {
                            throw new RuntimeException("Morph is null");
                    }

                    /*
                    if(morph instanceof MouselessControlWrap){
                        var wrapper = morph as MouselessControlWrap;
                        morph = wrapper.node;
                    }
                    */

                    if(morph instanceof Control) {
                        if(e.controlDown)
                            selectNode(morph);
                    }
                    else {
                        System.out.println("hello.....");
                        selectNode(morph);
                    }
            }
        }
    }
}

class MorphSlider extends Panel {

    public-init var root: MorphFxPanel;

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

//var morphPropertyPanel1 = MorphPropertyPanel {
    
//}

class MyActionListener extends ActionListener {
    var action: function(e: ActionEvent);
    override function actionPerformed (e : ActionEvent) : Void {
        if(action != null) action(e);
    }
}


class MorphFxPanel extends Panel {
    // used to show popup
    var swing: SwingComponent = SwingComponent.wrap(new JLabel(""));
    var lowest = Rectangle {
                width: bind this.width
                height: bind this.height
                stroke: Color.RED
                fill: Color.TRANSPARENT

                onMousePressed: function (e: MouseEvent) {
                    if(e.button == MouseButton.SECONDARY) {
                        showPopup(e);
                    }
                };
            };

    var morphContainer = MorphContainer {
        root: this
    };
    var morphSlides =  MorphSlider {
        root: this
        // morphContainer: bind morphContainer
    };
    var morphOutline: Node;
    var initialNodes: Node[];

    postinit {
        insert initialNodes into morphContainer.content;
        initialNodes = null;    // GC
    }

    override def width = bind scene.width;
    override def height = bind scene.width;

    override def content = bind [ swing, lowest, morphContainer, morphSlides, morphOutline ];

    function showPopup(e: MouseEvent){
        // show popup
        var popup = new JPopupMenu();

        {   // hide or show Slides
            var hide = if(morphSlides.visible) "hide" else "show";
            var toggleSliders = new JRadioButtonMenuItem("{hide} Sliders");
            toggleSliders.setActionCommand(hide);
            toggleSliders.addActionListener(MyActionListener {
                action: function(e: ActionEvent) {
                    morphSlides.visible = (e.getActionCommand() == "show");
                }
            });
            popup.add((toggleSliders));
        }

        {   // create new nodes
            def menu = new JMenu("create Controls");
            var createControlMenu = function(name: String, f: (function():Node)) {
                var menuItem = new JMenuItem(name);
                menu.add(menuItem);
                menuItem.addActionListener(MyActionListener{
                    action: function(e) {
                        var node = f();
                        insert node into morphContainer.content;
                    }
                });
            }
            createControlMenu("Button", function() {
                return Button { text: "Button" }
            });
            createControlMenu("Check Box", function() {
                return CheckBox { text: "Check Box" }
            });
            createControlMenu("Label", function() {
                return MouselessControlWrap {
                    node: Label { text: "Label" }
                }
            });
            createControlMenu("ListView", function() {
                return ListView { items: ["Hello", "World"] }
            });
            createControlMenu("Progress Bar", function() {
                return ProgressBar { progress: 0.5 }
            });
            createControlMenu("Progress Indicator", function() {
                var it = ProgressIndicator { progress: 0.5 };
                return MouselessControlWrap { node: it }
            });
            createControlMenu("Radio Button", function() {
                return RadioButton { text: "radio button" }
            });
            createControlMenu("Scroll Bar", function() {
                return ScrollBar { min: 1
                    max: 10
                    vertical: false
                }
            });
            createControlMenu("Slider", function() {
                return Slider { min: 1
                    max: 10
                    vertical: false
                }
            });
            createControlMenu("Text Box", function() {
                return TextBox { text: "radio button" }
            });
            createControlMenu("Toggle Button", function() {
                return ToggleButton { text: "toggle button" }
            });
            createControlMenu("Hyperlink", function() {
                return Hyperlink { text: "http://www.javafx.com" }
            });
            popup.add(menu);

        }

        {
            def menu = new JMenu("create Shapes");
            popup.add(menu);
        }


        popup.show(swing.getJComponent(), e.x, e.y);
    }

}


Stage {
    title: "MyApp"
    scene: Scene {
        width: 600
        height: 480

        content: [
            MorphFxPanel {
                initialNodes: [
                    textNode,
                    rectNode,
                    polygonNode,
                    btnNode,
                    polyLine,
                    textBox
                ]

            }
            //outline,
            //node3Outline,

        ]
    }
}

function debug(){
//    System.out.println("boundsInParent outline = {outline.boundsInParent} \n text = {textNode.boundsInParent}\n");
//    System.out.println("boundsInLocal outline = {outline.boundsInLocal} \n text = {textNode.boundsInLocal}")
}
