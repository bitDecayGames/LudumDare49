package entities;

import flixel.math.FlxPoint;
import ui.aura.Aura;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class RadioactiveCooler extends Block {
	public static inline var OGMO_NAME = "cooler";

	public var coolingAmount:Int = 0;
	public var radius:Int = 0;

	public var aura:Aura;
	
	public function new(_coolingAmount:Int = 2, _radius:Int = 1) {
		super(true);
		load_slices(AssetPaths.cooler_block__png, 16, 16, 16);

		coolingAmount = _coolingAmount;
		radius = _radius;
		aura = new Aura(0,0, FlxColor.CYAN, FlxPoint.get(-16, -16)).setFollow(this);
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
