package entities;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Exit extends FlxSprite {
	public static inline var OGMO_NAME = "exit";

	public function new() {
		super();
		makeGraphic(16, 16, FlxColor.WHITE);
		color = FlxColor.GREEN;
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
