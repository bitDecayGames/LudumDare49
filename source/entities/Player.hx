package entities;

import flixel.FlxG;
import helpers.Constants;
import spacial.Cardinal;
import depth.DepthSprite;

class Player extends DepthSprite {
	var speed:Float = 30;
	var turnSpeed:Float = 90;

	var dir = Cardinal.W.asVector();

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
		// FlxG.state.add(new Smoke(x, y));
	}
}
