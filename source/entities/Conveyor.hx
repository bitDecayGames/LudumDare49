package entities;

import flixel.FlxObject;
import spacial.Cardinal;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Conveyor extends FlxSprite {

	public var cardFacing:Cardinal;

	public function new(_cardFacing:Cardinal = Cardinal.N) {
		super();
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;

		cardFacing = _cardFacing;
	}

	override public function update(delta:Float) {
		super.update(delta);

	}
}
