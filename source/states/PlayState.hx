package states;

import ui.camera.SetupCameras;
import flixel.FlxCamera;
import entities.Conveyor;
import entities.RadioactiveCooler;
import helpers.Constants;
import entities.RadioactiveBlock;
import spacial.Cardinal;
import flixel.tweens.FlxTween;
import input.InputCalcuator;
import input.SimpleController;
import entities.Wall;
import entities.Block;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.util.FlxColor;
import depth.DepthSprite;
import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import entities.Player;
import flixel.FlxSprite;
import flixel.FlxG;
import systems.ControlSystem;
import levels.ogmo.Level;

using extensions.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var controlSystem:ControlSystem;

	var level:Level;
	var player:FlxSprite;

	var test:DepthSprite;

	var playerCollidables:FlxTypedGroup<Block> = new FlxTypedGroup();
	var collidables:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
	var nonCollidables:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();

	override public function create() {
		super.create();

		Lifecycle.startup.dispatch();

		// SetupCameras.SetupMainCamera(camera);

		level = new Level();
		add(level);

		// BEGIN TODO move to ogmo
		var wall = new Wall(66 + Constants.TILE_SIZE, 50);
		var radBlock = new RadioactiveBlock(1, 1000);
		radBlock.setPosition(66, 50);

		var radCooler = new RadioactiveCooler();
		radCooler.setPosition(66+(Constants.TILE_SIZE * 3), 50);

		var conveyor = new Conveyor();
		conveyor.setPosition(66+(Constants.TILE_SIZE * 3), 50+(Constants.TILE_SIZE * 5));

		collidables.add(wall);
		playerCollidables.add(wall);

		collidables.add(radBlock);
		playerCollidables.add(radBlock);

		collidables.add(radCooler);
		playerCollidables.add(radCooler);

		nonCollidables.add(conveyor);

		player = new Player(50, 50);
		collidables.add(player);
		// END TODO move to ogmo

		// test = new DepthSprite(32, 32);
		// test.load_slices(AssetPaths.test__png, Constants.TILE_SIZE, Constants.TILE_SIZE, Constants.TILE_SIZE);
		// test.angle = Math.random() * 360;
		// test.slice_offset = 0.5;
		add(collidables);
		add(playerCollidables);
		add(nonCollidables);
		add(test);

		controlSystem = new ControlSystem(player, playerCollidables, collidables, nonCollidables);
		add(controlSystem);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		// test.angle +=  30 * elapsed;
		// camera.angle +=  15 * elapsed;
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
