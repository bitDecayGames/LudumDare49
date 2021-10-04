package ui.counter;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import depth.DepthSprite;
import misc.FlxTextFactory;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.text.FlxText;

class Tooltip extends FlxTypedSpriteGroup<FlxSprite> {
	private static var yOffset = -20.0;

	private var follow:FlxObject;
	private var text:FlxText;
	private var arrow:DepthSprite;
	private var zVel:Float;

	public function new(x:Float, y:Float, text:String) {
		super();
		this.text = FlxTextFactory.make(text, 0, -30, 10, FlxTextAlign.CENTER);
		arrow = new DepthSprite(0, 0);
		arrow.load_slices(AssetPaths.arrow__png, 16, 2, 6);
		arrow.slice_offset = 1.5;
		zVel = 0;
		arrow.z = -10;
		add(arrow);
		add(this.text);

		this.x = x;
		this.y = y;
	}

	public function setFollow(obj:FlxObject):Tooltip {
		follow = obj;
		return this;
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		if (follow != null) {
			x = follow.x;
			y = follow.y + yOffset;
		}
		text.angle = 360 - camera.angle;
		arrow.angle += 1;
		zVel += 0.1;
		arrow.z += zVel;
		if (arrow.z > 0) {
			arrow.z = 0;
			zVel *= -1;
		}
	}
}
