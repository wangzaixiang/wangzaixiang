/*
 * Main.fx
 *
 * Created on Jan 11, 2010, 3:58:14 PM
 */

package learnjfx;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;
import javafx.scene.text.Font;

/**
 * @author 王在祥
 */

Stage {
    title: "Application title"
    scene: Scene {
        width: 250
        height: 80
        content: [
            Text {
                font : Font {
                    size : 16
                }
                x: 10
                y: 30
                content: "Application content"
            }
        ]
    }
}