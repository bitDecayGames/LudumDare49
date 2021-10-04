package states;

import depth.DepthSprite;
import depth.DepthUtil;
import entities.Block;
import entities.Player;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import levels.ogmo.Level;
import levels.ogmo.Room;
import signals.Lifecycle;
import signals.UI;
import systems.ControlSystem;
import ui.camera.SetupCameras;
import ui.legend.ActionLegend;

using extensions.FlxStateExt;

class CollidableBundle {
	public var playerCollidables:FlxTypedGroup<Block>;
	public var collidables:FlxTypedGroup<FlxSprite>;
	public var nonCollidables:FlxTypedGroup<FlxSprite>;
	public var uiObjs:FlxTypedGroup<FlxSprite>;
	public var sortGroup:FlxTypedGroup<DepthSprite> = new FlxTypedGroup();

	public function new(playerCollidables:FlxTypedGroup<Block>, collidables:FlxTypedGroup<FlxSprite>, nonCollidables:FlxTypedGroup<FlxSprite>,
			uiObjs:FlxTypedGroup<FlxSprite>, sortGroup:FlxTypedGroup<DepthSprite>) {
		this.playerCollidables = playerCollidables;
		this.collidables = collidables;
		this.nonCollidables = nonCollidables;
		this.uiObjs = uiObjs;
		this.sortGroup = sortGroup;
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

		var bundle = new CollidableBundle(playerCollidables, collidables, nonCollidables, uiObjs, sortGroup);

		level = new Level(AssetPaths.world1__json, bundle, startingRoomName);
		level.roomLoadedSignal.add(setCameraLocationRotation);
		level.loadFirstRoom();
		add(level);

		player = new Player(level.start.x, level.start.y);
		collidables.add(player);

		UI.setActionSteps.removeAll();
		UI.highlightActionStep.removeAll();
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

		if (controlSystem.lost() || FlxG.keys.justPressed.Q) {
			lose();
		}
	}

	public function lose() {
		SetupCameras.uiCamera = null;
		// TODO Indicate player lost
		FlxG.switchState(new PlayState(level.checkpointRoomName));
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}

	private function setCameraLocationRotation(r:Room) {
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
