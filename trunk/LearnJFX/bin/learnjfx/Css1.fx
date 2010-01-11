/*
 * Css1.fx
 *
 * Created on Jan 11, 2010, 3:58:33 PM
 */
package learnjfx;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;

/**
 * @author 王在祥
 */
// place your code here
Stage {
    title: "MyApp"
    scene: Scene {
        width: 200
        height: 200
        stylesheets: "{__DIR__}my.css"
        content: Text {
            content: "王在祥"
            x: 20 y: 100
        }
    }
}
