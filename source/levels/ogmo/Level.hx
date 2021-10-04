package levels.ogmo;

import metrics.Metrics;
import com.bitdecay.metrics.Metric;
import com.bitdecay.analytics.Bitlytics;
import systems.ControlSystem;
import states.CreditsState;
import haxefmod.flixel.FmodFlxUtilities;
import flixel.tweens.FlxTween;
import flixel.util.FlxSignal.FlxTypedSignal;
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
	var startingRoomName: String = null;

	var bundle:CollidableBundle;
	
	public var entrances:FlxTypedGroup<Entrance>;
	public var exits:FlxTypedGroup<Exit>;
	public var start:Entrance;
	public var end:Exit;


	public final roomLoadedSignal: FlxTypedSignal<(Room, Bool, ()->Void)-> Void> = new FlxTypedSignal<(Room, Bool, ()->Void)-> Void>();

	public var checkpointRoomName:String = null;

	public var controlSystem:ControlSystem = null;
	
	public function new(level:String, bundle:CollidableBundle, startingRoomName:String = null) {
		super();
		this.bundle = bundle;
		this.firstRoomName = startingRoomName;
		this.startingRoomName = startingRoomName;
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

	}

	public function checkExitCollision(player:Player) {
		if (!latestRoom.areAllCoresCharged()) {
			return;
		}

		if (!latestRoom.endUnlocked) {
			latestRoom.endUnlocked = true;
			for (e in latestRoom.exits) {
				FlxTween.tween(e, {
						alpha: 0,
						z: -32
					}, {
						onComplete: (t) -> {
							e.isActive = false;
						}
					});
			}
		}

		for (ex in latestRoom.exits) {
			if (controlSystem == null || !controlSystem.isMovementIdle()) {
				return;
			}

			var isGameWon = false;
			var moveToNextRoom = false;
			FlxG.overlap(ex, player, (exSpr, playerSpr) -> {
				Metrics.levelCompleted(0, ControlSystem.getMovesInLevel());
				if (ex.end) {
					isGameWon = true;
					return;
				}
				moveToNextRoom = true;
			});

			if (isGameWon) {
				FmodFlxUtilities.TransitionToState(new CreditsState(true));
			}
			if (moveToNextRoom) {
				latestRoom.unload();
				checkpointRoomName = ex.nextRoom;
				loadRoom(ex.nextRoom, true);
			}
		}
	}

	private function loadRoom(roomName: String, disablePlayer:Bool = false) {
		// reset moves on load
		ControlSystem.resetMovesInLevel();
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
		add(room.floor);

		for (ent in room.entrances) {
			if (room.name == firstRoomName) {
				if (start != null) {
					throw 'level start already set. room ${room.name}, first room ${firstRoomName}';
				}
				start = ent;
			}
			entrances.add(ent);
			ent.alpha = 0;
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
		roomLoadedSignal.dispatch(room, disablePlayer, fadeInEntrace);
	}

	function fadeInEntrace() {
		for (ent in entrances) {
			ent.z = -32;
			FlxTween.tween(ent,
				{
					alpha: 1,
					z: 0
				});
		}
	}

	public function loadFirstRoom() {
		if (startingRoomName != null) {
			checkpointRoomName = startingRoomName;
			loadRoom(startingRoomName);
			return;
		}

		checkpointRoomName = firstRoomName;
		loadRoom(firstRoomName);
	}
}
