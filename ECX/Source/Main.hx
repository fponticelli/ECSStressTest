package;

import ecx.Engine;
import ecx.World;
import ecx.WorldConfig;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Matrix;
import openfl.events.Event;
import openfl.display.FPS;

class Main extends Sprite
{
    private var world:World;

    public function new()
    {
        super();

        addEventListener(Event.ENTER_FRAME, init, false);
    }

    private function init(e:Event)
    {
        removeEventListener(Event.ENTER_FRAME, init, false);
        
        var config = new WorldConfig();
        config.add(new MotionSystem());
        config.add(new RunnerSystem());
        world = Engine.initialize().createWorld(config);

        var bullet = new Shape();
        bullet.graphics.beginFill(0x000000);
        bullet.graphics.drawCircle(0, 0, 3);
        bullet.graphics.endFill();

        var bounds = bullet.getBounds(bullet);
        var bitmapData = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), true, 0);

        var matrix = new Matrix();
        matrix.translate(-bounds.left, -bounds.top);
        bitmapData.draw(bullet, matrix);

        var tileset = new Tileset(bitmapData);
        tileset.addRect(bitmapData.rect);

        var tilemap = new Tilemap(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, tileset);

        for (i in 0...4000) {
            var entity = world.edit(world.create());
            var render:RenderComponent = entity.create(RenderComponent);
            var motion:MotionComponent = entity.create(MotionComponent);
            motion.vx = (Math.random() * 10) - 5;
            motion.vy = (Math.random() * 10) - 5;
            var tile = new Tile(0);
            tile.x = Math.ceil(Lib.current.stage.stageWidth / 2) + 10;
            tile.y = Math.ceil(Lib.current.stage.stageHeight / 2) + 10;
            render.tile = tile;
            tilemap.addTile(tile);
        }

        world.invalidate();

        addChild(tilemap);
        addChild(new FPS());
    }
}