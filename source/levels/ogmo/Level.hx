package levels.ogmo;

import states.PlayState.CollidableBundle;
import entities.Entrance;
import entities.Exit;
import flixel.FlxG;
import entities.HitBox;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import levels.ogmo.Room;
import helpers.Constants;

class Level extends FlxGroup {
	public var latestRoom:Room = null;
	var firstRoomName:String = null;
	var nameToRoom:Map<String, Room>;

	var bundle:CollidableBundle;
	
	public var entrances:FlxTypedGroup<Entrance>;
	public var exits:FlxTypedGroup<Exit>;
	public var start:Entrance;
	public var end:Exit;

	public function new(level:String, bundle:CollidableBundle) {
		super();
		this.bundle = bundle;

		var project = AssetPaths.project__ogmo;

		var loader = new FlxOgmo3Loader(project, level);

		nameToRoom = new Map<String, Room>();

		loader.loadEntities((entityData) -> {
			switch (entityData.name) {
				case Room.OGMO_NAME:
					var name = entityData.values.name;
					var room = new Room(project, name, entityData.x, entityData.y, entityData.width, entityData.height);
					nameToRoom[name] = room;

					if (entityData.values.start) {
						if (firstRoomName != null) {
							throw 'duplicate start room. ${firstRoomName} already set, ${name} attempted to override';
						}
						
						firstRoomName = name;
					}
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${Type.getClassName(Type.getClass(this))}';
			}
		}, "rooms");

		entrances = new FlxTypedGroup<Entrance>();
		exits = new FlxTypedGroup<Exit>();

		add(entrances);
		add(exits);

		loadRoom(firstRoomName);
	}

	private function loadRoom(roomName: String) {
		var room = nameToRoom[roomName];
		latestRoom = room;

		if (room.loaded) {
			trace('Level.loadRoom: ${roomName} already loaded, skipping');
			return;
		}

		room.load(bundle);

		for (r in nameToRoom) {
			for (ent in r.entrances) {
				if (ent.start) {
					if (start != null) {
						throw "level start already set";
					}
					start = ent;
				}
				entrances.add(ent);
			}
			for (ex in r.exits) {
				if (ex.end) {
					if (end != null) {
						throw "level end already set";
					}
					end = ex;
				}
				ex.loadRoomSignal.add(loadRoom);
				exits.add(ex);
			}
		}
	}
}
