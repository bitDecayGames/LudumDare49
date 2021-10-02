package levels.ogmo;

import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import entities.Entrance;
import entities.Exit;

class Room extends FlxGroup {
	public static inline var OGMO_NAME = "room";

	// public var layer:FlxTilemap;
	public var entrances:FlxTypedGroup<Entrance>;
	public var exits:FlxTypedGroup<Exit>;

	public function getErrorName() {
		return Type.getClassName(Type.getClass(this));
	}

	public function new(project: String, name:String, x:Int, y:Int, width:Int, height:Int) {
		super();

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

		entrances = new FlxTypedGroup<Entrance>();
		exits = new FlxTypedGroup<Exit>();

		loader.loadEntities((entityData) -> {
			var obj:FlxSprite;
			switch (entityData.name) {
				case Entrance.OGMO_NAME:
					var enter = new Entrance(entityData.values.start);
					entrances.add(enter);
					obj = enter;
				case Exit.OGMO_NAME:
					var exit = new Exit(entityData.values.end);
					exits.add(exit);
					obj = exit; 
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${getErrorName()}';
			}
			obj.x = entityData.x + x;
			obj.y = entityData.y + y;
		}, "objects");

		add(entrances);
		add(exits);

		// Links entrances and exits, validate
		// TODO
	}
}
