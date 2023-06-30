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
    private var tiles:Tilemap;

    public function new(levelName:String) {
        super(0, 0);
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
        }
    }

    public function updateGraphic() {
        tiles = new Tilemap(
            'graphics/tiles.png',
            walls.width, walls.height, walls.tileWidth, walls.tileHeight
        );
        for(tileX in 0...walls.columns) {
            for(tileY in 0...walls.rows) {
                if(walls.getTile(tileX, tileY)) {
                    tiles.setTile(tileX, tileY, 0);
                }
            }
        }
        graphic = tiles;
    }
}

