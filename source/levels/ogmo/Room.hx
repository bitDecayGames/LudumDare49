package levels.ogmo;

import states.PlayState.CollidableBundle;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import entities.Block;
import entities.Entrance;
import entities.Exit;
import entities.Conveyor;
import entities.Wall;
import entities.RadioactiveBlock;
import entities.RadioactiveCooler;
import entities.PowerCore;

class Room {
	public static inline var OGMO_NAME = "room";

	// public var layer:FlxTilemap;
	public var entrances:Array<Entrance> = [];
	public var exits:Array<Exit> = [];

	public function getErrorName() {
		return Type.getClassName(Type.getClass(this));
	}

	public function new(
		project: String,
		name:String,
		x:Int, y:Int,
		width:Int, height:Int,
		bundle:CollidableBundle
	) {
		var level = 'assets/levels/${name}.json';
		var loader = new FlxOgmo3Loader(project, level);
		// layer = loader.loadTilemap("<AssetPath to tilemap for layer>", "<layer name>");

		// Validate level data
		var levelWidth = loader.getLevelValue("width");
		if (levelWidth != width) {
			throw '${getErrorName()}: ${name} width mismatch. got ${levelWidth}, expected ${width}';
		}
		var levelHeight = loader.getLevelValue("height");
		if (levelHeight != height) {
			throw '${getErrorName()}: ${name} height mismatch. got ${levelHeight}, expected ${height}';
		}

		// entrance & exits
		loader.loadEntities((entityData) -> {
			var obj:FlxSprite;
			switch (entityData.name) {
				case Entrance.OGMO_NAME:
					var enter = new Entrance(entityData.values.start);
					entrances.push(enter);
					obj = enter;
				case Exit.OGMO_NAME:
					var exit = new Exit(entityData.values.end);
					exits.push(exit);
					obj = exit; 
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${getErrorName()}';
			}
			obj.x = entityData.x + x;
			obj.y = entityData.y + y;
		}, "objects");

		// noncollidables
		loader.loadEntities((entityData) -> {
			var obj:FlxSprite;
			switch (entityData.name) {
				case Conveyor.OGMO_NAME:
					obj = new Conveyor();
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${getErrorName()}';
			}
			obj.x = entityData.x + x;
			obj.y = entityData.y + y;
			bundle.nonCollidables.add(obj);
		}, "noncollidables");


		// collidables
		loader.loadEntities((entityData) -> {
			var obj:Block;
			switch (entityData.name) {
				case Wall.OGMO_NAME:
					obj = new Wall();
				case RadioactiveCooler.OGMO_NAME:
					obj = new RadioactiveCooler();
				case RadioactiveBlock.OGMO_NAME:
					obj = new RadioactiveBlock(entityData.values.decayAmount, entityData.values.maxLife);
				case PowerCore.OGMO_NAME:
					obj = new PowerCore(entityData.values.maxCharge);
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${getErrorName()}';
			}
			obj.x = entityData.x + x;
			obj.y = entityData.y + y;

			bundle.collidables.add(obj);
			bundle.playerCollidables.add(obj);
		}, "collidables");
	}
}
