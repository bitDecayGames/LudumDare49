package entities;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Entrance extends FlxSprite {
	public static inline var OGMO_NAME = "entrance";

	public function new() {
		super();
		makeGraphic(16, 16, FlxColor.WHITE);
		color = FlxColor.RED;
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
