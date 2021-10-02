package states;

import signals.UI;
import ui.legend.ActionLegend;
import ui.minimap.MiniMap;
import ui.camera.SetupCameras;
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

using extensions.FlxStateExt;

class LoganState extends FlxTransitionableState {
	var player:Player;

	var depthSprites:FlxTypedGroup<DepthSprite>;

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		SetupCameras.SetupMainCamera(camera);
		add(new MiniMap());
		add(new ActionLegend());
		UI.setActionSteps.dispatch([MOVEMENT, COOLING, CONVEYOR, DECAY]);

		for (i in 0...20) {
			var conveyor = new FlxSprite(FlxG.random.int(0, FlxG.width), FlxG.random.int(0, FlxG.height));
			conveyor.loadGraphic(AssetPaths.conveyor__png, true, 16, 16);
			conveyor.animation.add('play', [for (i in 0...8) i], 8);
			conveyor.animation.play('play');
			conveyor.angle = Math.random() * 360;
			add(conveyor);
		}

		depthSprites = new FlxTypedGroup();
		add(depthSprites);

		var xpos = 32;
		var ypos = 80;
		for (i in 0...10) {
			var test = new DepthSprite(xpos, ypos);
			var asset = AssetPaths.wall_square__png;
			if (i == 0 || i == 9) {
				asset = AssetPaths.wall_round__png;
			}

			if (i == 9) {
				test.angle = 180;
			}

			test.load_slices(asset, 16, 16, 16);
			test.slice_offset = 0.5;
			depthSprites.add(test);

			xpos += 16;
		}

		player = new Player(50, 50);
		depthSprites.add(player);
		FlxG.camera.follow(player);
		SetupCameras.minimapCamera.follow(player);

		for (i in 0...20) {
			var test = new DepthSprite(FlxG.random.int(0, FlxG.width), FlxG.random.int(0, FlxG.height));
			test.load_slices(AssetPaths.crate__png, 16, 16, 16);
			test.angle = Math.random() * 360;
			test.slice_offset = 0.5;
			depthSprites.add(test);

			test = new DepthSprite(FlxG.random.int(0, FlxG.width), FlxG.random.int(0, FlxG.height));
			test.load_slices(AssetPaths.battery__png, 16, 16, 13);
			test.angle = Math.random() * 360;
			test.slice_offset = 0.5;
			depthSprites.add(test);

			test = new DepthSprite(FlxG.random.int(0, FlxG.width), FlxG.random.int(0, FlxG.height));
			test.load_slices(AssetPaths.cooler_block__png, 16, 16, 16);
			test.angle = Math.random() * 360;
			test.slice_offset = 1;
			depthSprites.add(test);
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		camera.angle += 15 * elapsed;

		depthSprites.sort(DepthUtil.sort_by_depth);
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
