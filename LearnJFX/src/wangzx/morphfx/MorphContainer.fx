/*
 * MorphContainer.fx
 *
 * Created on Jan 17, 2010, 1:21:59 PM
 */

package wangzx.morphfx;

import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.control.Control;
import javafx.scene.input.MouseEvent;
import java.lang.RuntimeException;
import java.lang.System;

/**
 * 所有创建的元素的容器，部分的元素有可能使用了wrapper进行了包装，以便处理事件
 */
public class MorphContainer extends Group {

    public-init var root: MorphWorkspace;
    // the Morph Control Pad

    //var outline: MorphOutline; // child of root
    public-read var selected: Node;

    function selectNode(node: Node) {
        System.out.println("select Node {node}");
        selected = node;
        root.morphOutline = if(node==null) null else MorphEditor {
            node: node
        }
    }

    /**
    * 对所有的元素添加鼠标事件，点击后可以可视化编辑
    */
    override var content on replace oldValue[firstIndex .. lastIndex] = newValue {
        // add event for each morph
        for(node in content) {
            node.blocksMouse = true; //
            if(node.onMousePressed == null and not (node instanceof MorphEditor))
                node.onMousePressed = function(e: MouseEvent) {
                    // check e.node
                    var morph: Node = e.node;
                    while(morph != null and morph.parent != this) {
                        morph = morph.parent;
                    }

                    if(morph == null) {
                            throw new RuntimeException("Morph is null");
                    }

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

