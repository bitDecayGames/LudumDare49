package entities;

import flixel.FlxObject;
import spacial.Cardinal;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Grate extends FlxSprite {
	public static inline var OGMO_NAME = "grate";

	public function new() {
		super();
		loadGraphic(AssetPaths.floor_tiles__png, true, 16, 16);
		animation.frameIndex = 16;
	}

	override public function update(delta:Float) {
		super.update(delta);

	}
}
