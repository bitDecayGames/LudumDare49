package states;

import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import levels.ogmo.MasterLevel;

using extensions.FlxStateExt;

class JakeCTState extends FlxTransitionableState {
	var masterLevel:MasterLevel;

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.camera.bgColor = FlxColor.GRAY;
		FlxG.camera.pixelPerfectRender = true;

		masterLevel = new MasterLevel();
		add(masterLevel);
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
