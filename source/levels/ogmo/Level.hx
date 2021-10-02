package levels.ogmo;

import entities.Entrance;
import entities.Exit;
import flixel.FlxG;
import entities.HitBox;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import levels.ogmo.Room;

class Level extends FlxGroup {
	public var rooms: Array<Room> = [];
	public var entrances: FlxTypedGroup<Entrance>;
	public var exits: FlxTypedGroup<Exit>;

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
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${Type.getClassName(Type.getClass(this))}';
			}
		}, "rooms");

		entrances = new FlxTypedGroup<Entrance>();
		exits = new FlxTypedGroup<Exit>();

		for (r in rooms) {
			for (ent in r.entrances) {
				entrances.add(ent);
			}
			for (ex in r.exits) {
				exits.add(ex);
			}
		}

		add(entrances);
		add(exits);

		// Links entrances and exits, validate
		var hitbox = new HitBox(3 * Constants.TILE_SIZE, 3 * Constants.TILE_SIZE);
		trace("starting entrance/exit linking...");
		entrances.forEach((enterSpr) -> {
			var enter = cast(enterSpr, Entrance);
			hitbox.x = enter.x - Constants.TILE_SIZE;
			hitbox.y = enter.y - Constants.TILE_SIZE;
			trace(hitbox);
			FlxG.overlap(exits, hitbox, (exitSpr, hitboxSpr) -> {
				var exit = cast (exitSpr, Exit);
				if (exit.getEntrance() != null && enter.getExit() != null) {
					trace('${exit} & ${enter} already linked, skipping');
					return;
				}

				trace('linking ${exit} & ${enter}');

				exit.setEntrance(enter);
				enter.setExit(exit);
				trace('${exit} & ${enter} linked');
			});
		});

		trace("validating entrance/exit linking...");
		entrances.forEach((enter) -> {
			enter.validateExit();
		});
		exits.forEach((exit) -> {
			exit.validateEntrance();
		});
		trace("entrance/exit linking complete");
	}
}
