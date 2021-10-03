package states;

import helpers.SimpleDepthSprite;
import input.SimpleController;
import flixel.util.FlxColor;
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

using extensions.FlxStateExt;

class MikeState extends FlxTransitionableState {
	var a:DepthSprite;
	var b:SimpleDepthSprite;

	override public function create() {
		super.create();

		Lifecycle.startup.dispatch();

		camera.bgColor = FlxColor.GREEN;

		a = new DepthSprite(0, 0);
		a.load_slices(AssetPaths.test__png, 16, 16, 16);
		camera.follow(a);
		add(a);

		b = new SimpleDepthSprite();
		b.load_slices(AssetPaths.test__png, 16, 16, 16);
		add(b);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (SimpleController.pressed(Button.LEFT)) {
			a.x -= 3;
		}
		if (SimpleController.pressed(Button.RIGHT)) {
			a.x += 3;
		}
		if (SimpleController.pressed(Button.UP)) {
			a.y -= 3;
		}
		if (SimpleController.pressed(Button.DOWN)) {
			a.y += 3;
		}
		camera.angle += elapsed * 2;
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
