package entities;

import haxepunk.*;
import haxepunk.utils.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.masks.*;

class AirCurrent extends Entity {
    public static inline var CURRENT_POWER = 660;
    public static inline var CURRENT_CANCEL_POWER = 100;

    public var sprite:Spritemap;

    public function new(x:Float, y:Float, width:Int, height:Int) {
        super(x, y);
        type = "aircurrent";
        mask = new Hitbox(width, height);
        //sprite = new TiledSpritemap("graphics/aircurrent.png", 10, 10, width, height);
        //sprite.play("idle");
        //sprite.alpha = 0.5;
        //graphic = sprite;
        graphic = Image.createRect(width, height, 0xADD8E6);
        graphic.alpha = 0.5;
    }

    public override function update() {
        super.update();
    }
}

