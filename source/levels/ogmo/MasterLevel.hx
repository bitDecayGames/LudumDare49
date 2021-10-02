package levels.ogmo;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import levels.ogmo.Room;

class MasterLevel extends FlxGroup {
	public var rooms: Array<Room> = [];

	public function new() {
		super();

		var project = AssetPaths.project__ogmo;
		var level = AssetPaths.master__json;

		var loader = new FlxOgmo3Loader(project, level);

		loader.loadEntities((entityData) -> {
			switch (entityData.name) {
				case Room.OGMO_NAME:

					var room = new Room(project, entityData.values.name, entityData.x, entityData.y, entityData.width, entityData.height);
					rooms.push(room);
					add(room);
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${Type.getClassName(Type.getClass(this))}';
			}
		}, "rooms");
	}
}
