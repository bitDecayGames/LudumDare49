package levels.ogmo;

import entities.Player;
import states.PlayState.CollidableBundle;
import entities.Entrance;
import entities.Exit;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import levels.ogmo.Room;
import flixel.FlxG;

class Level extends FlxGroup {
	public var latestRoom:Room = null;
	var firstRoomName:String = null;
	var nameToRoom:Map<String, Room>;

	var bundle:CollidableBundle;
	
	public var entrances:FlxTypedGroup<Entrance>;
	public var exits:FlxTypedGroup<Exit>;
	public var start:Entrance;
	public var end:Exit;

	public var checkpointRoomName:String = null;

	public function new(level:String, bundle:CollidableBundle, startingRoomName:String = null) {
		super();
		this.bundle = bundle;
		this.firstRoomName = startingRoomName;

		var project = AssetPaths.project__ogmo;

		var loader = new FlxOgmo3Loader(project, level);

		nameToRoom = new Map<String, Room>();

		loader.loadEntities((entityData) -> {
			switch (entityData.name) {
				case Room.OGMO_NAME:
					var name = entityData.values.name;
					var room = new Room(project, name, entityData.x, entityData.y, entityData.width, entityData.height);
					nameToRoom[name] = room;

					if (entityData.values.start && startingRoomName == null) {
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

		if (startingRoomName != null) {
			checkpointRoomName = startingRoomName;
			loadRoom(startingRoomName);
			return;
		}

		checkpointRoomName = firstRoomName;
		loadRoom(firstRoomName);
	}

	public function checkExitCollision(player:Player) {
		if (!latestRoom.areAllCoresCharged()) {
			return;
		}

		for (ex in latestRoom.exits) {
			var isGameWon = false;
			var moveToNextRoom = false;
			FlxG.overlap(ex, player, (exSpr, playerSpr) -> {
				if (ex.end) {
					isGameWon = true;
					return;
				}
				moveToNextRoom = true;
			});

			if (isGameWon) {
				throw 'TODO Game won fill me in';
			}
			if (moveToNextRoom) {
				checkpointRoomName = ex.nextRoom;
				loadRoom(ex.nextRoom);
			}
		}
	}

	private function loadRoom(roomName: String) {
		var room = nameToRoom[roomName];
		if (room == null) {
			throw 'room ${roomName} not found in level';
		}

		latestRoom = room;

		if (room.loaded) {
			trace('Level.loadRoom: ${roomName} already loaded, skipping');
			return;
		}

		room.load(bundle);

		for (ent in room.entrances) {
			if (room.name == firstRoomName) {
				if (start != null) {
					throw 'level start already set. room ${room.name}, first room ${firstRoomName}';
				}
				start = ent;
			}
			entrances.add(ent);
		}
		for (ex in room.exits) {
			if (ex.end) {
				if (end != null) {
					throw "level end already set";
				}
				end = ex;
			}
			exits.add(ex);
		}
	}
}
