package entities;

import flixel.FlxObject;
import spacial.Cardinal;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Conveyor extends FlxSprite {
	public static inline var OGMO_NAME = "conveyor";

	public var cardFacing:Cardinal;

	public function new(_cardFacing:Cardinal = Cardinal.N) {
		super();
		loadGraphic(AssetPaths.conveyor__png, true, 16, 16);
		animation.add("stop", [0], 0);
		animation.add("go", [ for(i in 0...9) i], 10);
		animation.play("stop");
		cardFacing = _cardFacing;
	}

	override public function update(delta:Float) {
		super.update(delta);

	}
}
