package entities;

import flixel.tweens.FlxTween;
import flixel.FlxG;
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
		this.dir = dir;
		FlxTween.tween(this, { angle: dir + 90 }, 0.2);
	}

	override public function update(delta:Float) {
		super.update(delta);

		if (emittingSmoke > 0) {
			emittingSmoke -= delta;
			curSmoke -= smokeTimer;
			if (curSmoke < smokeTimer) {
				curSmoke = smokeTimer;
				smoke();
			}
		}
	}

	public function emitSmoke(forSeconds:Float = .2, secondsPerSmoke:Float = 0.1) {
		smokeTimer = secondsPerSmoke;
		emittingSmoke = forSeconds;
	}

	private function smoke() {
		// TODO: MW add offset to x,y so it looks like it is coming out the back
		var smokeX = 0.0;
		var smokeY = 0.0;

		switch(dir) {
			case N: 
				smokeX = x + 16;
				smokeY = y - 24;
			case S:
				smokeX = x;
				smokeY = y-16;
			case E:
				smokeX = x;
				smokeY = y - 16;
			case W:
				smokeX = x + width;
				smokeY = y - 32;
			default:
		};

		FlxG.state.add(new Smoke(smokeX, smokeY));
	}
}
