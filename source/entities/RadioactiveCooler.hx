package entities;

import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class RadioactiveCooler extends Block {
	public static inline var OGMO_NAME = "cooler";

	public var coolingAmount:Int = 0;
	public var radius:Int = 0;

	public function new(_coolingAmount:Int = 2, _radius:Int = 1) {
		super(true);
		load_slices(AssetPaths.cooler_block__png, 16, 16, 16);

		coolingAmount = _coolingAmount;
		radius = _radius;
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
