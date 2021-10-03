package entities;

import helpers.Constants;
import spacial.Cardinal;
import depth.DepthSprite;

class Player extends DepthSprite {

	var speed:Float = 30;
	var turnSpeed:Float = 90;

	var dir = Cardinal.W.asVector();

	public function new(x:Float = 0, y:Float = 0, ?slicesPath:String) {
		super(x, y);
		if (slicesPath == null){
			load_slices(AssetPaths.player__png, Constants.TILE_SIZE, Constants.TILE_SIZE, 24);
		} else {
			load_slices(slicesPath, Constants.TILE_SIZE, Constants.TILE_SIZE, 24);
		}
		// test.angle = Math.random() * 360;
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}

