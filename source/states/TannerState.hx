package states;

import flixel.tweens.misc.VarTween;
import flixel.util.FlxTimer;
import ui.camera.SetupCameras;
import helpers.Constants;
import systems.ControlSystem;
import entities.Conveyor;
import entities.RadioactiveCooler;
import entities.RadioactiveBlock;
import entities.Wall;
import entities.Block;
import dialogmanager.DialogManager;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import depth.DepthUtil;
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
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxTween;

using extensions.FlxStateExt;


// Text position
// Typing speed
// Text size

class TannerState extends FlxTransitionableState {
	var player:Player;
	var playerOff:Player;

	var dialogManager:DialogManager;
	var sirenLight:FlxSprite;

	var controlSystem:ControlSystem;
	var playerCollidables:FlxTypedGroup<Block> = new FlxTypedGroup();
	var collidables:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
	var nonCollidables:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();

	var turnedOn = false;

	var tween:VarTween;

	// SFX
	var typeSoundId = "Typewriter";
	var sirenId = "siren";
	var lowPass = false;
	var sirensOff = false;

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		SetupCameras.SetupMainCamera(camera);
		SetupCameras.SetupUICamera();

		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		camera.bgColor = FlxColor.GRAY;

		FlxG.camera.pixelPerfectRender = true;

		var dialgs = new Map<String, Array<String>>();
		dialgs["Intro"] = ["Intercom: System power at 0%", "Intercom: Meltdown imminent", "Intercom: Engaging all available Pocobots to recharge facitility power cores",
		 "Pocobot: ...", "Pocobot: .................powering on", "Pocobot: beep boop", "Pocobot: Power core straight ahead", "Pocobot: I must do my duty"];
		dialogManager = new DialogManager(dialgs, this, SetupCameras.uiCamera, FlxKey.SPACE, 
			() -> {FmodManager.PlaySoundAndAssignId(FmodSFX.Typewriter, typeSoundId);}, 
			() -> {FmodManager.StopSoundImmediately(typeSoundId);});
		dialogManager.loadDialog("Intro");


		player = new Player(50, 50);
		playerOff = new Player(50, 50, AssetPaths.player_off__png);
		
		collidables.add(player);
		collidables.add(playerOff);

		var wall = new Wall(669 + Constants.TILE_SIZE, 50);
		var radBlock = new RadioactiveBlock(1, 1000);
		radBlock.setPosition(player.x-48, player.y);

		var radCooler = new RadioactiveCooler();
		radCooler.setPosition(669+(Constants.TILE_SIZE * 3), 50);

		var conveyor = new Conveyor();
		conveyor.setPosition(669+(Constants.TILE_SIZE * 3), 50+(Constants.TILE_SIZE * 5));
		
		collidables.add(wall);
		playerCollidables.add(wall);

		collidables.add(radBlock);
		playerCollidables.add(radBlock);

		collidables.add(radCooler);
		playerCollidables.add(radCooler);

		nonCollidables.add(conveyor);


		// test = new DepthSprite(32, 32);
		// test.load_slices(AssetPaths.test__png, Constants.TILE_SIZE, Constants.TILE_SIZE, Constants.TILE_SIZE);
		// test.angle = Math.random() * 360;
		// test.slice_offset = 0.5;
		add(collidables);
		add(playerCollidables);
		add(nonCollidables);

		controlSystem = new ControlSystem(player, playerCollidables, collidables, nonCollidables);
		controlSystem.playerIscontrollable = false;
		add(controlSystem);

			
		sirenLight = new FlxSprite(FlxG.width*-5, FlxG.height*-5);
		sirenLight.makeGraphic(FlxG.width*10, FlxG.height*10, FlxColor.RED);
		sirenLight.alpha = .8;
		add(sirenLight);

		FmodManager.PlaySong(FmodSongs.EmergencyPowerActivated);
		FmodManager.PlaySoundWithReference(FmodSFX.Siren);	
		tween = FlxTween.tween(sirenLight, {alpha: 0}, 2, {
			type: FlxTweenType.LOOPING,
		});
		
        FlxG.camera.zoom = 2;
		camera.angle = -90;
		FlxG.camera.follow(player);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		dialogManager.update(elapsed);

		FlxG.watch.addQuick("ID", dialogManager.getCurrentDialogPage());

		if(dialogManager.getCurrentDialogPage() == 3) {
			if(!lowPass) {
				FlxTween.tween(camera, {zoom: 4}, 3, {});
			}
			lowPass = true;
		}

		if (FlxG.keys.pressed.Z){
			FmodManager.StopSongImmediately();
			FmodManager.StopSoundImmediately(sirenId);
			sirenLight.visible = false;
		}

		if(dialogManager.getCurrentDialogPage() == 4) { 
			if(!turnedOn){
				new FlxTimer().start(2).onComplete = function(t:FlxTimer) {
					playerOff.visible = false;
					FmodManager.PlaySoundOneShot(FmodSFX.PowerUp);
				}
				turnedOn = true;
			}
		}

		if(dialogManager.getCurrentDialogPage() == 8) {
			if(lowPass) {
				FlxTween.tween(camera, {zoom: 2}, 1, {});
			}
			lowPass = false;
			controlSystem.playerIscontrollable = true;
			tween.destroy();
		}

		if(lowPass){
			FmodManager.SetEventParameterOnSong("LowPass", 1);
			FmodManager.SetEventParameterOnSound(sirenId, "LowPass", 1);
		} else {
			FmodManager.SetEventParameterOnSong("LowPass", 0);
			FmodManager.SetEventParameterOnSound(sirenId, "LowPass", 0);
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
}
