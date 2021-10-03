package ui.counter;

import flixel.FlxObject;
import flixel.text.FlxText;

class Counter extends FlxText {
	private static var yOffset = -10.0;

	private var count:Int = 0;
	private var follow:FlxObject;

	public function new(x:Float, y:Float, count:Int) {
		super(x, y, '${count}');
	}

	public function setCount(count:Int):Counter {
		this.count = count;
		text = '${count}';
		return this;
	}

	public function setFollow(obj:FlxObject):Counter {
		follow = obj;
		return this;
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		if (follow != null) {
			x = follow.x;
			y = follow.y + yOffset;
			angle = 360 - camera.angle;
		}
	}
}
