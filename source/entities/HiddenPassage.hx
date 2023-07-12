package entities;

import haxepunk.*;
import haxepunk.utils.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.masks.*;
import haxepunk.math.*;

class HiddenPassage extends Entity {
    public var isRevealed(default, null):Bool;

    public function new(x:Float, y:Float, passageWidth:Int, passageHeight:Int, walls:Grid) {
        super(x, y);
        layer = -20;
        type = "hiddenpassage";
        mask = new Hitbox(passageWidth + 2, passageHeight + 2, -1, -1);
        //sprite = new TiledSpritemap("graphics/hiddenpassage.png", 10, 10, width, height);
        //sprite.play("idle");
        //sprite.alpha = 0.5;
        //graphic = sprite;
        //graphic = Image.createRect(width, height, 0xFF40FF);
        //graphic.alpha = 0.5;
        var bricksImage = new Image("graphics/walls.png");
        var bricks = new Tilemap(
            'graphics/walls.png',
            passageWidth, passageHeight, walls.tileWidth, walls.tileHeight
        );
        var lace = new Tilemap(
            'graphics/lace.png',
            passageWidth, passageHeight, walls.tileWidth, walls.tileHeight
        );
        var tileOutline = new Tilemap(
            'graphics/tileoutline.png',
            passageWidth, passageHeight, walls.tileWidth, walls.tileHeight
        );
        var maxBrickTileX = Std.int(bricksImage.width / walls.tileWidth);
        var maxBrickTileY = Std.int(bricksImage.height / walls.tileHeight);
        var tileXOffset = x / walls.tileWidth;
        var tileYOffset = y / walls.tileHeight;
        for(tileX in 0...bricks.columns) {
            for(tileY in 0...bricks.rows) {
                var tile = Std.int(
                    ((tileX + tileXOffset) % maxBrickTileX)
                    + ((tileY + tileYOffset) % maxBrickTileY) * maxBrickTileX
                );
                bricks.setTile(tileX, tileY, tile);
                lace.setTile(tileX, tileY, tile);
                if(Random.random < 0.5) {
                    tileOutline.setTile(tileX, tileY, HXP.choose(0, 1, 2, 3));
                }
            }
        }
        graphic = new Graphiclist([bricks, tileOutline, lace]);
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

