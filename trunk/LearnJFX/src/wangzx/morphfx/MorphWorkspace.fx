/*
 * MorphFxPanel.fx
 *
 * Created on Jan 17, 2010, 1:23:56 PM
 */

package wangzx.morphfx;

import javafx.ext.swing.SwingComponent;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Hyperlink;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.ProgressBar;
import javafx.scene.control.ProgressIndicator;
import javafx.scene.control.RadioButton;
import javafx.scene.control.ScrollBar;
import javafx.scene.control.Slider;
import javafx.scene.control.TextBox;
import javafx.scene.control.ToggleButton;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Panel;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import java.awt.event.ActionEvent;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JPopupMenu;
import javax.swing.JRadioButtonMenuItem;


public class MorphWorkspace extends Panel {
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

    public var morphContainer = MorphContainer {
        root: this
    };
    public var morphSlides =  MorphSlider {
        root: this
        // morphContainer: bind morphContainer
    };
    public var morphOutline: Node;
    public-init var initialNodes: Node[];

    postinit {
        insert initialNodes into morphContainer.content;
        initialNodes = null;    // GC
    }

    override def width = bind scene.width;
    override def height = bind scene.width;

    override def content = bind [ swing, lowest, morphContainer, morphSlides, morphOutline ];

    // Workspace's Popup
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

