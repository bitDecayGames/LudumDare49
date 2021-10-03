package particles;

import flixel.FlxG;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import depth.DepthSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class SmokeEmitter extends FlxTypedEmitter<SmokeParticle> {
	private static var maxCapacity = 100;

	public function new(x:Float, y:Float) {
		super(x, y, maxCapacity);

		makeParticles();
	}

	public override function update(delta:Float) {
		if (FlxG.keys.justPressed.SPACE) {
			start(true, 0.1, 1);
		}
	}
}
