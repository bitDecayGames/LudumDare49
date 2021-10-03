package ui.legend;

import flixel.addons.ui.FlxUI9SliceSprite;
import openfl.geom.Rectangle;

class LegendTray extends FlxUI9SliceSprite {
	private var legendItemHeight:Int;
	private var count:Int;
	private var padding:Float;

	public function new(legendWidth:Int, legendItemHeight:Int, count:Int, padding:Float) {
		super(0, 0, AssetPaths.tray__9__png, new Rectangle(0, 0, legendWidth + padding, legendItemHeight * count + padding), [5, 5, 12, 12]);
		this.legendItemHeight = legendItemHeight;
		this.padding = padding;
		setCount(count);
		var halfPadding = padding * .5;
		x -= halfPadding;
		y -= halfPadding;
	}

	public function setCount(count:Int) {
		this.count = count;

		resize(width, legendItemHeight * count + padding);
	}
}
