package ui.legend;

import flixel.FlxSprite;
import flixel.addons.ui.FlxUI9SliceSprite;
import openfl.geom.Rectangle;

class LegendHighlight extends FlxUI9SliceSprite {
	private var legendItemHeight:Int;

	private var orderPosition:Int = 0;
	private var target:Float;
	private var start:Float;
	private var moving:Bool;
	private var timer:Float;
	private var maxTime:Float;
	private var rootY:Float;

	public function new(rootY:Float, legendWidth:Int, legendItemHeight:Int) {
		super(0, 0, AssetPaths.highlight__9__png, new Rectangle(0, 0, legendWidth, legendItemHeight), [4, 4, 12, 12]);
		x = 0;
		y = 0;
		this.legendItemHeight = legendItemHeight;
		setRootY(rootY);
		setOrderPosition(0, 0); // start out in first position and snap to it
	}

	public function setRootY(rootY:Float) {
		this.rootY = rootY;
	}

	public function getOrderPosition():Int {
		return orderPosition;
	}

	public function setOrderPosition(orderPosition:Int, seconds:Float = 0.05) {
		this.orderPosition = orderPosition;
		start = y;
		target = orderPosition * legendItemHeight + rootY;
		moving = true;
		timer = 0;
		maxTime = seconds;
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);

		if (moving) {
			if (maxTime > 0) {
				timer += elapsed;
				if (timer > maxTime) {
					timer = maxTime;
					y = target;
					moving = false;
				} else {
					y = start + (target - start) * (timer / maxTime);
				}
			} else {
				y = target;
				moving = false;
			}
		}
	}
}
