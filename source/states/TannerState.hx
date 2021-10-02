package states;

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

	var dialogManager:DialogManager;
	var sirenLight:FlxSprite;

	// SFX
	var typeSoundId = "Typewriter";

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		camera.bgColor = FlxColor.GRAY;

		FlxG.camera.pixelPerfectRender = true;
	
		sirenLight = new FlxSprite(0,0);
		sirenLight.makeGraphic(FlxG.width, FlxG.height, FlxColor.RED);
		sirenLight.alpha = .8;
		add(sirenLight);

		FmodManager.PlaySong(FmodSongs.EmergencyPowerActivated);
		FmodManager.PlaySoundOneShot(FmodSFX.Siren);	
		FlxTween.tween(sirenLight, {alpha: 0}, 2, {
			type: FlxTweenType.LOOPING,
			onComplete: function(_)
			{
				FmodManager.PlaySoundOneShot(FmodSFX.Siren);	
			}
		});

		var dialgs = new Map<String, Array<String>>();
		dialgs["Intro"] = ["Intercom: System power at 0%", "Intercom: Meltdown imminent", "Intercom: Engaging all available Pocobots to recharge facitility power cores",
		 "Pocobot: ...", "Pocobot: .................powering on", "Pocobot: beep boop", "Pocobot: Power core straight ahead", "I must do my duty"];
		dialogManager = new DialogManager(dialgs, this, this.camera, FlxKey.SPACE, 
			() -> {FmodManager.PlaySoundAndAssignId(FmodSFX.Typewriter, typeSoundId);}, 
			() -> {FmodManager.StopSoundImmediately(typeSoundId);});
		dialogManager.loadDialog("Intro");

	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		dialogManager.update(elapsed);
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
