package entities;

import flixel.tweens.FlxTween;
import helpers.Constants;
import spacial.Cardinal;
import depth.DepthSprite;

class Player extends DepthSprite {
	var speed:Float = 30;
	var turnSpeed:Float = 90;

	// player's initial facing is east because of the art
	var dir = Cardinal.E;

	var emittingSmoke:Float = 0.0;
	var smokeTimer:Float = 0.25;
	var curSmoke:Float = 0.0;

	public function new(x:Float = 0, y:Float = 0, ?slicesPath:String) {
		super(x, y);
		if (slicesPath == null) {
			load_slices(AssetPaths.player__png, Constants.TILE_SIZE, Constants.TILE_SIZE, 24);
		} else {
			load_slices(slicesPath, Constants.TILE_SIZE, Constants.TILE_SIZE, 24);
		}
		// test.angle = Math.random() * 360;
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;
	}

	public function setDir(dir:Cardinal) {
		var currentDir = this.dir;
		var targetDir = dir + 90;

		if (currentDir == 360 && targetDir == 90) {
			currentDir = 0;
		} else if (currentDir == 90 && targetDir == 360) {
			targetDir = 0;
		} else if (currentDir == 0 && (targetDir == 360 || targetDir == 270)) {
			currentDir = 360;
		}

		FlxTween.angle(this, currentDir, targetDir, 0.2);
		this.dir = targetDir;
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
