package entities;

import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class RadioactiveCooler extends FlxSprite {

	var coolingAmount:Int = 0;
	var radius:Int = 0;

	public function new(_coolingAmount:Int = 2, _radius:Int = 1) {
		super();
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;

		coolingAmount = _coolingAmount;
		radius = _radius;
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
