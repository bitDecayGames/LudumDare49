package entities;

import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class PowerCore extends Block {
	public static inline var OGMO_NAME = "core";

	var currentCharge:Int = 0;
	var maxCharge:Int = 0;

	public function new(_maxCharge:Int = 10) {
		super(true);
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;

		maxCharge = _maxCharge;
	}

	override public function update(delta:Float) {
		super.update(delta);
	}

	public function fullyCharged()
	{
		return currentCharge == maxCharge;
	}

	public function charge(chargeAmount:Int)
	{
		currentCharge += chargeAmount;

		if (currentCharge > maxCharge)
		{
			currentCharge = maxCharge;
		}
	}
}
