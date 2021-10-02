package entities;

import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class RadioactiveBlock extends Blocks {

	var decayAmount:Int = 0;
	var maxLife:Int = 0;
	var currentLife:Int = 0;
	var blowedUp:Bool = false;

	public function new(_decayAmount:Int = 1, _maxLife:Int = 10) {
		super(true);
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;

		decayAmount = _decayAmount;
		maxLife = _maxLife;
		currentLife = maxLife;
	}

	override public function update(delta:Float) {
		super.update(delta);
	}

	public function meltedDown() {
		return blowedUp;
	}

	public function decay() {
		currentLife -= decayAmount;

		//wtf <=
		if (currentLife < 0)
		{
			currentLife = 0;
			blowedUp = true;
		}
	}

	public function cool(coolAmount:Int)
	{
		currentLife += coolAmount;

		if (currentLife > maxLife)
		{
			currentLife = maxLife;
		}
	}
}
