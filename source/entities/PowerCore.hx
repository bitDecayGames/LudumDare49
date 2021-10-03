package entities;

import ui.counter.Counter;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.tweens.FlxTween;
import helpers.Constants;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class PowerCore extends Block {
	public static inline var OGMO_NAME = "core";

	public var currentCharge:Int = 0;
	var maxCharge:Int = 0;
	
	public var counter:Counter;

	public function new(_maxCharge:Int = 10) {
		super(true);
		load_slices(AssetPaths.battery__png, Constants.TILE_SIZE, Constants.TILE_SIZE, 16);
		maxCharge = _maxCharge;
		slice_offset = 1;
		FlxTween.tween(this, {slice_offset: 1.5}, 3, 
			{
				type: FlxTweenType.PINGPONG,
				ease: FlxEase.quadInOut
			});
			
		counter = new Counter(0, 0, currentCharge).setFollow(this);
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

		counter.setCount(currentCharge);
	}
}
