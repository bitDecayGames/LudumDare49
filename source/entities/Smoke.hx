package entities;

import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import depth.DepthSprite;
import flixel.FlxSprite;
import flixel.FlxSprite.IFlxSprite;

class Smoke extends DepthSprite {
	private static var rnd:FlxRandom = new FlxRandom();

	private var maxHealth:Float = 0;

	public function new(x:Float, y:Float, ?velocity:FlxVector) {
		super(x, y);
		load_slices(AssetPaths.smoke__png, 8, 8, 4);
		if (velocity != null) {
			this.velocity = velocity;
		}
		pickRandoms();
	}

	public function pickRandoms() {
		visible = false;
		health = rnd.float(1, 2);
		maxHealth = health;
		angle = rnd.int(0, 360);
		angularVelocity = rnd.int(70, 120);
		if (rnd.int(0, 10) % 2 == 0) {
			angularVelocity = angularVelocity * -1.0;
		}
		setScaleAndAlpha();
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		visible = true;
		setScaleAndAlpha();
		z -= elapsed * 10;
		health -= elapsed;
		if (health < 0) {
			kill();
		}
	}

	private function setScaleAndAlpha() {
		var percent = health / maxHealth;
		var invPer = (1.0 - percent) + 0.25;
		scale = FlxPoint.get(invPer, invPer);
		alpha = percent;
	}
}
