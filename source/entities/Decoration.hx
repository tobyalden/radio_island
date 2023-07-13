package entities;

import haxepunk.*;
import haxepunk.utils.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.masks.*;

class Decoration extends Entity {

    public function new(x:Float, y:Float, fileName:String, drawLayer:Int) {
        super(x, y);
        graphic = new Image('graphics/decorations/${fileName}.png');
        layer = drawLayer;
        //var sprite = new Image('graphics/decorations/${fileName}.png');
        //var sprite2 = new Image('graphics/decorations/${fileName}.png');
        //HXP.tween(sprite, {x: 2}, 0.5 * 2, {ease: Ease.sineInOut, type: TweenType.PingPong});
        //HXP.tween(sprite2, {x: 3}, 0.8 * 2, {ease: Ease.sineInOut, type: TweenType.PingPong});
        //graphic = new Graphiclist([sprite, sprite2]);
    }
}
