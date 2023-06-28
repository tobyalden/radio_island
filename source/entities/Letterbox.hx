package entities;

import haxepunk.*;
import haxepunk.utils.*;
import haxepunk.graphics.*;
import scenes.*;

class Letterbox extends Entity {

    private var blackBars:Graphiclist;
    private var leftBar:Image;
    private var rightBar:Image;
    private var topBar:Image;
    private var bottomBar:Image;

    public function new() {
        super(0, 0);
        blackBars = new Graphiclist();
        leftBar = Image.createRect(1, 1, 0x000000);
        rightBar = Image.createRect(1, 1, 0x000000);
        topBar = Image.createRect(1, 1, 0x000000);
        bottomBar = Image.createRect(1, 1, 0x000000);
        for(bar in [leftBar, rightBar, topBar, bottomBar]) {
            blackBars.add(bar);
        }
        blackBars.scrollX = 0;
        blackBars.scrollY = 0;
        graphic = blackBars;
    }

    public override function update() {
        var sideBarWidth = (HXP.width - GameScene.GAME_WIDTH) / 2;
        leftBar.scaleX = sideBarWidth;
        leftBar.scaleY = HXP.height;
        rightBar.x = sideBarWidth + GameScene.GAME_WIDTH;
        rightBar.scaleX = sideBarWidth;
        rightBar.scaleY = HXP.height;
        var topAndBottomBarHeight = (HXP.height - GameScene.GAME_HEIGHT) / 2;
        topBar.scaleX = HXP.width;
        topBar.scaleY = topAndBottomBarHeight;
        bottomBar.y = topAndBottomBarHeight + GameScene.GAME_HEIGHT;
        bottomBar.scaleX = HXP.width;
        bottomBar.scaleY = topAndBottomBarHeight;
    }
}
