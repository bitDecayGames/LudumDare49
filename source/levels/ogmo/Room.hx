package levels.ogmo;

import flixel.math.FlxPoint;
import spacial.Cardinal;
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
import entities.Grate;
import entities.FastForward;

class Room {
	public static inline var OGMO_NAME = "room";

	public var name:String;
	public var loaded:Bool = false;

	var project:String;
	var x:Int;
	var y:Int;
	var width:Int;
	var height:Int;

	public var cameraPosition: FlxPoint = FlxPoint.get();
	public var cameraRotation: Float = 0;

	// public var layer:FlxTilemap;
	public var entrances:Array<Entrance> = [];
	public var exits:Array<Exit> = [];
	var cores:Array<PowerCore> = [];

	public function new(project:String, name:String, x:Int, y:Int, width:Int, height:Int) {
		this.project = project;
		this.name = name;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public function areAllCoresCharged() {
		return cores.filter((c) -> c.fullyCharged()).length == cores.length;
	}

	public function load(bundle:CollidableBundle) {
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
					var enter = new Entrance();
					entrances.push(enter);
					bundle.sortGroup.add(enter);
					obj = enter;
				case Exit.OGMO_NAME:
					var exit = new Exit(entityData.values.end, entityData.values.nextRoom);
					exits.push(exit);
					bundle.sortGroup.add(exit);
					obj = exit;
				case 'camera':
					cameraPosition.set(entityData.x + x , entityData.y +y);
					cameraRotation = entityData.rotation;
					return;
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
					var card = Cardinal.fromFloat(entityData.rotation);
					trace("this card of this conveyor: " + card);
					obj = new Conveyor(card);
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${getErrorName()}';
			}
			obj.x = entityData.x + x - entityData.originX;
			obj.y = entityData.y + y - entityData.originY;
			bundle.nonCollidables.add(obj);
		}, "noncollidables");

		// collidables
		loader.loadEntities((entityData) -> {
			var obj:FlxSprite;
			switch (entityData.name) {
				case Wall.OGMO_NAME:
					obj = new Wall();
					bundle.playerCollidables.add(cast(obj, Block));
				case RadioactiveCooler.OGMO_NAME:
					obj = new RadioactiveCooler();
					bundle.playerCollidables.add(cast(obj, Block));
				case RadioactiveBlock.OGMO_NAME:
					var radioActiveBlock = new RadioactiveBlock(entityData.values.decayAmount, entityData.values.maxLife);
					bundle.playerCollidables.add(cast(radioActiveBlock, Block));
					bundle.uiObjs.add(radioActiveBlock.counter);
					obj = radioActiveBlock;
				case PowerCore.OGMO_NAME:
					var core = new PowerCore(entityData.values.maxCharge);
					bundle.playerCollidables.add(core);
					bundle.uiObjs.add(core.counter);
					cores.push(core);
					obj = core;
				case Grate.OGMO_NAME:
					obj = new Grate();
				case FastForward.OGMO_NAME:
					obj = new FastForward();
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${getErrorName()}';
			}
			obj.x = entityData.x + x;
			obj.y = entityData.y + y;

			bundle.collidables.add(obj);
		}, "collidables");

		loaded = true;
	}

	public function getErrorName() {
		return Type.getClassName(Type.getClass(this));
	}
}
