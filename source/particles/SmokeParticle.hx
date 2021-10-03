package particles;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.util.helpers.FlxRange;
import flixel.effects.particles.FlxParticle.IFlxParticle;
import depth.DepthSprite;

class SmokeParticle extends DepthSprite implements IFlxParticle {
	public var lifespan:Float;

	public var age(default, null):Float;

	public var percent(default, null):Float;

	public var autoUpdateHitbox:Bool;

	public var velocityRange:FlxRange<FlxPoint>;

	public var angularVelocityRange:FlxRange<Float>;

	public var scaleRange:FlxRange<FlxPoint>;

	public var alphaRange:FlxRange<Float>;

	public var colorRange:FlxRange<FlxColor>;

	public var dragRange:FlxRange<FlxPoint>;

	public var accelerationRange:FlxRange<FlxPoint>;

	public var elasticityRange:FlxRange<Float>;

	public function onEmit() {}

	public function new(x:Float, y:Float) {
		super(x, y);
		load_slices(AssetPaths.smoke__png, 16, 16, 16);
	}

	public override function update(delta:Float) {
		z += delta * 0.1;
	}
}
