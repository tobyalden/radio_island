package entities;

import haxepunk.*;
import haxepunk.utils.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.masks.*;

class Vibe extends Entity {

    public var backgroundName(default, null):String;

    public function new(x:Float, y:Float, width:Int, height:Int, backgroundName:String) {
        super(x, y);
        this.backgroundName = backgroundName;
        type = "vibe";
        mask = new Hitbox(width, height);
    }
}
