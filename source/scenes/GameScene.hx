package scenes;

import entities.*;
import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import openfl.Assets;

class GameScene extends Scene
{
    public static inline var GAME_WIDTH = 240;
    public static inline var GAME_HEIGHT = 180;

    private var player:Player;

    override public function begin() {
        var level = new Level("level");
        add(level);
        for(entity in level.entities) {
            add(entity);
            if(Type.getClass(entity) == Player) {
                player = cast(entity, Player);
            }
        }
        add(new Letterbox());
    }

    override public function update() {
        super.update();
        var cameraOffsetX = (HXP.width - GameScene.GAME_WIDTH) / 2;
        var cameraOffsetY = (HXP.height - GameScene.GAME_HEIGHT) / 2;
        camera.setTo(
            Math.floor(player.centerX / GAME_WIDTH) * GAME_WIDTH - cameraOffsetX,
            Math.floor(player.centerY / GAME_HEIGHT) * GAME_HEIGHT - cameraOffsetY,
            0, 0
        );
    }
}
