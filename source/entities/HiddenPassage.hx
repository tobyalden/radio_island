package entities;

import haxepunk.*;
import haxepunk.utils.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.masks.*;

class HiddenPassage extends Entity {
    public var isRevealed(default, null):Bool;

    public function new(x:Float, y:Float, width:Int, height:Int) {
        super(x, y);
        type = "hiddenpassage";
        mask = new Hitbox(width + 2, height + 2, -1, -1);
        //sprite = new TiledSpritemap("graphics/hiddenpassage.png", 10, 10, width, height);
        //sprite.play("idle");
        //sprite.alpha = 0.5;
        //graphic = sprite;
        graphic = Image.createRect(width, height, 0xFF40FF);
        //graphic.alpha = 0.5;
        isRevealed = false;
    }

    public override function update() {
        if(collide("player", x, y) != null) {
            reveal();
        }
        super.update();
    }

    public function reveal() {
        if(isRevealed) {
            return;
        }
        isRevealed = true;
        HXP.tween(graphic, {"alpha": 0}, 0.25);
        var connectedPassages = [];
        collideInto("hiddenpassage", x, y, connectedPassages);
        for(connectedPassage in connectedPassages) {
            cast(connectedPassage, HiddenPassage).reveal();
        }
    }
}
