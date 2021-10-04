package states;

import flixel.tweens.FlxTween;
import levels.ogmo.Room;
import flixel.math.FlxPoint;
import depth.DepthUtil;
import depth.DepthSprite;
import entities.Block;
import entities.Player;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import levels.ogmo.Level;
import signals.Lifecycle;
import signals.UI;
import systems.ControlSystem;
import ui.camera.SetupCameras;
import ui.legend.ActionLegend;
import ui.minimap.MiniMap;
import flixel.FlxG;

using extensions.FlxStateExt;

class CollidableBundle {
	public var playerCollidables:FlxTypedGroup<Block>;
	public var collidables:FlxTypedGroup<FlxSprite>;
	public var nonCollidables:FlxTypedGroup<FlxSprite>;
	public var uiObjs:FlxTypedGroup<FlxSprite>;

	public function new(playerCollidables:FlxTypedGroup<Block>, collidables:FlxTypedGroup<FlxSprite>, nonCollidables:FlxTypedGroup<FlxSprite>,
			uiObjs:FlxTypedGroup<FlxSprite>) {
		this.playerCollidables = playerCollidables;
		this.collidables = collidables;
		this.nonCollidables = nonCollidables;
		this.uiObjs = uiObjs;
	}
}

class PlayState extends FlxTransitionableState {
	var controlSystem:ControlSystem;

	var level:Level;
	var player:Player;

	var test:DepthSprite;

	var playerCollidables:FlxTypedGroup<Block> = new FlxTypedGroup();
	var collidables:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
	var nonCollidables:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
	var uiObjs:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();

	var sortGroup:FlxTypedGroup<DepthSprite> = new FlxTypedGroup();

	var startingRoomName:String = null;

	public function new(startingRoomName:String = null) {
		super();

		this.startingRoomName = startingRoomName;
	}

	override public function create() {
		super.create();

		Lifecycle.startup.dispatch();

		SetupCameras.SetupMainCamera(camera);

		var bundle = new CollidableBundle(playerCollidables, collidables, nonCollidables, uiObjs);

		level = new Level(AssetPaths.world1__json, bundle, startingRoomName);
		level.roomLoadedSignal.add(setCameraLocationRotation);
		level.loadFirstRoom();
		add(level);

		player = new Player(level.start.x, level.start.y);
		collidables.add(player);

		add(new ActionLegend());
		UI.setActionSteps.dispatch([MOVEMENT, COOLING, CONVEYOR, DECAY, CHARGE]);
		// add(new MiniMap());

		add(collidables);
		add(playerCollidables);
		add(nonCollidables);
		add(test);
		add(sortGroup);
		add(uiObjs); // this is last here so text draws on top of everything
		
		sortGroup.add(player);
		controlSystem = new ControlSystem(player, playerCollidables, collidables, nonCollidables);
		add(controlSystem);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		for (m in playerCollidables.members) {
			sortGroup.add(m);
		}
		sortGroup.sort(DepthUtil.sort_by_depth);
		level.checkExitCollision(player);

		if(controlSystem.lost()) {
			// TODO Indicate player lost
			FlxG.switchState(new PlayState(level.checkpointRoomName));
		}
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}

	private function setCameraLocationRotation(r: Room){

		camera.focusOn(r.cameraPosition);


		FlxTween.tween(camera, {
			angle: r.cameraRotation
		});

		FlxTween.tween(camera.scroll, {
			x: r.cameraPosition.x - camera.width * 0.5,
			y: r.cameraPosition.y - camera.height * 0.5
		});

	}
}
