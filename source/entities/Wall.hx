package entities;

import flixel.FlxObject;
import spacial.Cardinal;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Wall extends Blocks {

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y, false);
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;
		load_slices(AssetPaths.wall_square__png, 16, 16, 16);
		slice_offset = 0.5;
	}

	override public function update(delta:Float) {
		super.update(delta);

	}
}
