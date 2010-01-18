/*
 * MyActionListener.fx
 *
 * Created on Jan 17, 2010, 1:25:34 PM
 */

package wangzx.morphfx;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class MyActionListener extends ActionListener {
    public var action: function(e: ActionEvent);
    override function actionPerformed (e : ActionEvent) : Void {
        if(action != null) action(e);
    }
}
