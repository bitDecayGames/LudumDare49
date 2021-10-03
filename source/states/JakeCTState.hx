package states;

import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import levels.ogmo.Level;

using extensions.FlxStateExt;

class JakeCTState extends FlxTransitionableState {
	var level:Level;

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.camera.bgColor = FlxColor.GRAY;
		FlxG.camera.pixelPerfectRender = true;

		// level = new Level();
		// add(level);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
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
