package entities;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.tweens.FlxTween;
import depth.DepthSprite;
import flixel.FlxObject;
import spacial.Cardinal;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class FastForward extends DepthSprite {
	public static inline var OGMO_NAME = "fastforward";

	public function new() {
		super();
		load_slices(AssetPaths.ff_button__png, 16, 16, 16);
		slice_offset = 1;
		FlxTween.tween(this, {slice_offset: 1.5}, 2, 
			{
				type: FlxTweenType.LOOPING,
				ease: FlxEase.quadInOut
			});
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
