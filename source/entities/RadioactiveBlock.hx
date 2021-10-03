package entities;

import ui.counter.Counter;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class RadioactiveBlock extends Block {
	public static inline var OGMO_NAME = "radioactive";

	var decayAmount:Int = 0;
	var maxLife:Int = 0;
	var currentLife:Int = 0;
	var blowedUp:Bool = false;

	public var counter:Counter;

	public function new(_decayAmount:Int = 1, _maxLife:Int = 10) {
		super(true);
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;

		decayAmount = _decayAmount;
		maxLife = _maxLife;
		currentLife = maxLife;
		counter = new Counter(0, 0, currentLife).setFollow(this);
	}

	override public function update(delta:Float) {
		super.update(delta);
	}

	public function meltedDown() {
		return blowedUp;
	}

	public function decay() {
		currentLife -= decayAmount;

		if (currentLife < 0) {
			currentLife = 0;
			blowedUp = true;
		}
		counter.setCount(currentLife);
	}

	public function cool(coolAmount:Int) {
		currentLife += coolAmount;

		if (currentLife > maxLife) {
			currentLife = maxLife;
		}
		counter.setCount(currentLife);
	}
}
