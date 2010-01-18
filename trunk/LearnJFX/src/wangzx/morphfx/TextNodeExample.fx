/*
 * TextNodeExample.fx
 *
 * Created on Jan 11, 2010, 9:59:35 PM
 */
package wangzx.morphfx;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;
import javafx.scene.text.Font;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.control.Button;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Polyline;
import javafx.scene.control.TextBox;

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


Stage {
    title: "MyApp"
    scene: Scene {
        width: 600
        height: 480

        content: [
            MorphWorkspace {
                initialNodes: [
                    textNode,
                    rectNode,
                    polygonNode,
                    btnNode,
                    polyLine,
                    textBox
                ]

            }

        ]
    }
}
