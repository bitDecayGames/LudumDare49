package entities;

import flixel.FlxObject;
import spacial.Cardinal;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class FastForward extends FlxSprite {
	public static inline var OGMO_NAME = "fastforward";

	public function new() {
		super();
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
