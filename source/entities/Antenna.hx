package entities;

import haxepunk.*;
import haxepunk.utils.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.masks.*;

class Antenna extends Entity {
    public var isActivated(default, null):Bool;
    public var allSprites(default, null):Graphiclist;
    private var pulse:MultiVarTween;
    private var lights:Image;

    public function new(x:Float, y:Float) {
        super(x, y);
        mask = new Hitbox(40, 40);
        var sprite = new Image('graphics/radiotower1.png');
        lights = new Image('graphics/radiolights.png');
        lights.alpha = 0.8;
        pulse = HXP.tween(lights, {alpha: 0}, 2, {ease: Ease.sineInOut, type: TweenType.PingPong, tweener: this});
        lights.color = 0xFF0000;
        layer = 20;
        var backlight = new Image('graphics/radiotowerbacklight.png');
        backlight.color = 0xffbf00;
        backlight.alpha = 0.7;
        HXP.tween(backlight, {alpha: 0.5}, 4, {ease: Ease.sineInOut, type: TweenType.PingPong, tweener: this});
        allSprites = new Graphiclist([backlight, sprite, lights]);
        allSprites.originX = sprite.width / 2 - 20;
        allSprites.originY = sprite.height - 40;
        graphic = allSprites;
        isActivated = false;
    }

    private function activate() {
        isActivated = true;
        lights.color = 0x00FF00;
        pulse.active = false;
        lights.alpha = 0.9;
    }

    override public function update() {
        if(!isActivated && collide("player", x, y) != null) {
            activate();
        }
        if(isActivated) {
            lights.alpha= Math.random() > 0.1 ? 0.9 : 0.333;
        }
        super.update();
    }
}

