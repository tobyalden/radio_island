package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import openfl.Assets;

class Level extends Entity
{
    public var entities(default, null):Array<Entity>;
    private var walls:Grid;

    public function new(levelName:String) {
        super(0, 0);
        layer = -10;
        type = "walls";
        loadLevel(levelName);
        updateGraphic();
    }

    override public function update() {
        super.update();
    }

    private function loadLevel(levelName:String) {
        var levelData = haxe.Json.parse(Assets.getText('levels/${levelName}.json'));
        for(layerIndex in 0...levelData.layers.length) {
            var layer = levelData.layers[layerIndex];
            if(layer.name == "walls") {
                // Load solid geometry
                walls = new Grid(levelData.width, levelData.height, layer.gridCellWidth, layer.gridCellHeight);
                for(tileY in 0...layer.grid2D.length) {
                    for(tileX in 0...layer.grid2D[0].length) {
                        walls.setTile(tileX, tileY, layer.grid2D[tileY][tileX] == "1");
                    }
                }
                mask = walls;
            }
            else if(layer.name == "entities") {
                // Load entities
                entities = new Array<Entity>();
                for(entityIndex in 0...layer.entities.length) {
                    var entity = layer.entities[entityIndex];
                    if(entity.name == "player") {
                        entities.push(new Player(entity.x, entity.y - 2));
                    }
                    if(entity.name == "air_current") {
                        entities.push(new AirCurrent(entity.x, entity.y, entity.width, entity.height));
                    }
                    if(entity.name == "hidden_passage") {
                        entities.push(new HiddenPassage(entity.x, entity.y, entity.width, entity.height));
                    }
                }
            }
            else if(layer.name == "vibes") {
                // Load vibes
                for(vibeIndex in 0...layer.entities.length) {
                    var vibe = layer.entities[vibeIndex];
                    entities.push(new Vibe(vibe.x, vibe.y, vibe.width, vibe.height, vibe.values.background));
                }
            }
        }
    }

    public function updateGraphic() {
        var bricksImage = new Image("graphics/walls.png");
        var bricks = new Tilemap(
            'graphics/walls.png',
            walls.width, walls.height, walls.tileWidth, walls.tileHeight
        );
        var lace = new Tilemap(
            'graphics/lace.png',
            walls.width, walls.height, walls.tileWidth, walls.tileHeight
        );
        var tileOutline = new Tilemap(
            'graphics/tileoutline.png',
            walls.width, walls.height, walls.tileWidth, walls.tileHeight
        );
        var maxBrickTileX = Std.int(bricksImage.width / walls.tileWidth);
        var maxBrickTileY = Std.int(bricksImage.height / walls.tileHeight);
        var grassImage = new Image("graphics/grass.png");
        var grass = new Tilemap(
            'graphics/grass.png',
            walls.width, walls.height, walls.tileWidth, walls.tileHeight
        );
        var maxGrassTileX = Std.int(grassImage.width / walls.tileWidth);
        for(tileX in 0...walls.columns) {
            for(tileY in 0...walls.rows) {
                if(walls.getTile(tileX, tileY)) {
                    var tile = ((tileX % maxBrickTileX) + (tileY % maxBrickTileY) * maxBrickTileX);
                    bricks.setTile(tileX, tileY, tile);
                    lace.setTile(tileX, tileY, tile);
                    if(Random.random < 0.5) {
                        tileOutline.setTile(tileX, tileY, HXP.choose(0, 1, 2, 3));
                    }
                }
                else if(walls.getTile(tileX, tileY + 1)) {
                    var tile = tileX % maxGrassTileX;
                    if(Random.random < 0.75) {
                        tile += maxGrassTileX;
                    }
                    grass.setTile(tileX, tileY, tile);
                }
            }
        }
        graphic = new Graphiclist([bricks, tileOutline, lace, grass]);
    }
}

