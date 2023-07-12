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
    public static inline var SAVE_FILE_NAME = "radioisland";
    public static inline var DEBUG_MOVE_SPEED = 400;
    public static inline var BACKGROUND_FADE_SPEED = 2;

    private var player:Player;
    private var level:Level;
    private var backgrounds:Map<String, Backdrop>;
    private var backgroundTweener:VarTween;

    override public function begin() {
        Data.load(SAVE_FILE_NAME);

        backgrounds = [
            "default" => new Backdrop("graphics/background.png"),
            "sky" => new Backdrop("graphics/sky.png"),
        ];
        for(backgroundName in backgrounds.keys()) {
            addGraphic(backgrounds[backgroundName], 100);
            backgrounds[backgroundName].alpha = 0;
        }

        //var foliage = new Backdrop("graphics/foliage.png");
        //addGraphic(foliage, 40);
        //HXP.tween(foliage, {x: 3}, 4, {ease: Ease.sineInOut, type: TweenType.PingPong});

        //var foliageDupe = new Backdrop("graphics/foliage.png");
        //addGraphic(foliageDupe, 40);
        //HXP.tween(foliageDupe, {x: 5}, 6, {ease: Ease.sineInOut, type: TweenType.PingPong});

        //var foliage2 = new Backdrop("graphics/foliage2.png");
        //addGraphic(foliage2, 60);
        //HXP.tween(foliage2, {x: 7}, 8, {ease: Ease.sineInOut, type: TweenType.PingPong});

        //var shadows = new Backdrop("graphics/shadows.png");
        //addGraphic(shadows, 20);
        //HXP.tween(shadows, {x: -48}, 6.9, {ease: Ease.sineInOut, type: TweenType.PingPong});
        //HXP.tween(shadows, {y: -24}, 12.3, {ease: Ease.sineInOut, type: TweenType.PingPong});

        //var rainbow = new Backdrop("graphics/rainbow.png");
        //addGraphic(rainbow, -100);
        //rainbow.alpha = 0.1;
        //HXP.tween(rainbow, {x: -43}, 11.9, {ease: Ease.sineInOut, type: TweenType.PingPong});
        //HXP.tween(rainbow, {y: 19}, 8.3, {ease: Ease.sineInOut, type: TweenType.PingPong});

        //var glow = new Backdrop("graphics/glow.png");
        //glow.alpha = 0.2;
        //addGraphic(glow, -20);
        //HXP.tween(glow, {x: -38}, 7.9, {ease: Ease.sineInOut, type: TweenType.PingPong});
        //HXP.tween(glow, {y: -44}, 9.3, {ease: Ease.sineInOut, type: TweenType.PingPong});

        level = new Level("level");
        add(level);
        for(entity in level.entities) {
            add(entity);
            if(Type.getClass(entity) == Player) {
                player = cast(entity, Player);
                player.x = Data.read("playerX", player.x);
                player.y = Data.read("playerY", player.y);
            }
        }
        add(new Letterbox());
    }

    override public function update() {
        debug();
        super.update();

        // Level wrap-around
        if(player.centerX < 0) {
            player.x += level.width;
        }
        if(player.centerX > level.width) {
            player.x -= level.width;
        }

        // Check vibes & update backgrounds
        var currentBackgroundName = "default";
        var vibe = player.collide("vibe", player.x, player.y);
        if(vibe != null) {
            currentBackgroundName = cast(vibe, Vibe).backgroundName;
        }
        for(backgroundName in backgrounds.keys()) {
            if(backgroundName == currentBackgroundName) {
                backgrounds[backgroundName].alpha = Math.min(
                    backgrounds[backgroundName].alpha
                    + HXP.elapsed * BACKGROUND_FADE_SPEED,
                    1
                );
            }
            else {
                backgrounds[backgroundName].alpha = Math.max(
                    backgrounds[backgroundName].alpha
                    - HXP.elapsed * BACKGROUND_FADE_SPEED,
                    0
                );
            }
        }

        var cameraOffsetX = (HXP.width - GameScene.GAME_WIDTH) / 2;
        var cameraOffsetY = (HXP.height - GameScene.GAME_HEIGHT) / 2;
        camera.setTo(
            Math.floor(player.centerX / GAME_WIDTH) * GAME_WIDTH - cameraOffsetX,
            Math.floor(player.centerY / GAME_HEIGHT) * GAME_HEIGHT - cameraOffsetY,
            0, 0
        );
    }


    private function debug() {
        player.active = !(Key.check(Key.DIGIT_0) || Key.check(Key.DIGIT_9));

        // Debug movement (screen by screen)
        if(Key.check(Key.DIGIT_0)) {
            if(Key.pressed(Key.A)) {
                player.x -= GameScene.GAME_WIDTH;
            }
            if(Key.pressed(Key.D)) {
                player.x += GameScene.GAME_WIDTH;
            }
            if(Key.pressed(Key.W)) {
                player.y -= GameScene.GAME_HEIGHT;
            }
            if(Key.pressed(Key.S)) {
                player.y += GameScene.GAME_HEIGHT;
            }

        }

        // Debug movement (smooth)
        if(Key.check(Key.DIGIT_9)) {
            if(Key.check(Key.A)) {
                player.x -= DEBUG_MOVE_SPEED * HXP.elapsed;
            }
            if(Key.check(Key.D)) {
                player.x += DEBUG_MOVE_SPEED * HXP.elapsed;
            }
            if(Key.check(Key.W)) {
                player.y -= DEBUG_MOVE_SPEED * HXP.elapsed;
            }
            if(Key.check(Key.S)) {
                player.y += DEBUG_MOVE_SPEED * HXP.elapsed;
            }
        }

        // Camera
        if(Key.check(Key.C)) {
            camera.scale = 0.1;
        }
        else {
            camera.scale = 1;
        }

        // Resetting
        if(Key.pressed(Key.R)) {
            if(Key.check(Key.SHIFT)) {
                Data.clear();
            }
            else {
                Data.write("playerX", player.x);
                Data.write("playerY", player.y);
                Data.save(SAVE_FILE_NAME);
            }
            HXP.scene = new GameScene();
        }
    }
}
