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

	public var layer:FlxTilemap;
	public var objects:FlxGroup;

	public function new(project: String, name:String) {
		super();

		var loader = new FlxOgmo3Loader(project, 'assets/levels/$name.json');
		// layer = loader.loadTilemap("<AssetPath to tilemap for layer>", "<layer name>");

		objects = new FlxGroup();

		loader.loadEntities((entityData) -> {
			var obj:FlxSprite;
			switch (entityData.name) {
				case Entrance.OGMO_NAME:
					obj = new Entrance();
				case Exit.OGMO_NAME:
					obj = new Exit();
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${Type.getClassName(Type.getClass(this))}';
			}
			obj.x = entityData.x;
			obj.y = entityData.y;
			objects.add(obj);
		}, "objects");

		add(objects);
	}
}
