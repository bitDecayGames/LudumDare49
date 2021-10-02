package states;

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

using extensions.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var player:FlxSprite;

	var test:DepthSprite;

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		camera.bgColor = FlxColor.GRAY;

		FlxG.camera.pixelPerfectRender = true;

		player = new Player(50, 50);
		add(player);

		// test = new DepthSprite(32, 32);
		// test.load_slices(AssetPaths.test__png, 16, 16, 16);
		// test.angle = Math.random() * 360;
		// test.slice_offset = 0.5;
		add(test);
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
