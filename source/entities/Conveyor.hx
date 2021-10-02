package entities;

import flixel.FlxObject;
import spacial.Cardinal;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Conveyor extends FlxSprite {

	public function new(_facing:Int = FlxObject.RIGHT) {
		super();
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;

		facing = _facing;
	}

	override public function update(delta:Float) {
		super.update(delta);

	}
}
