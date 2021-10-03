package states;

import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import entities.Smoke;
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
	override public function create() {
		super.create();

		Lifecycle.startup.dispatch();

		camera.bgColor = FlxColor.GREEN;

		SetupCameras.SetupMainCamera(camera);

		camera.focusOn(FlxPoint.get(0, 0));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (SimpleController.just_pressed(Button.LEFT) || SimpleController.just_pressed(Button.RIGHT)) {
			add(new Smoke(0, 0, FlxVector.get(1, 1).scale(10)));
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
