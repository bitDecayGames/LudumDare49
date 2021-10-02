package ui.legend;

import flixel.util.FlxColor;
import misc.FlxTextFactory;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;

class LegendItem extends FlxSpriteGroup {
	private static var iconOffset:Float = 18.0;
	private static var labelOffset:Float = 40.0;
	private static var orderNumberOffset:Float = 5.0;
	private static var textColor = FlxColor.fromRGB(105, 105, 105);
	private static var textSize = 10;

	private var icon:FlxSprite;
	private var label:FlxText;
	private var orderNumber:FlxText;

	public function new(icon:FlxSprite, label:String, orderNumber:Int) {
		super();
		setIcon(icon);
		this.label = FlxTextFactory.make(label, labelOffset, 0, textSize, FlxTextAlign.LEFT, textColor);
		add(this.label);
		this.orderNumber = FlxTextFactory.make("" + (orderNumber + 1), orderNumberOffset, 0, textSize, FlxTextAlign.LEFT, textColor);
		add(this.orderNumber);
	}

	public function setIcon(icon:FlxSprite) {
		if (this.icon != null) {
			remove(this.icon);
		}
		add(icon);
		icon.x = x + iconOffset;
		icon.y = y;
		icon.width = 50;
		icon.height = 50;
		this.icon = icon;
	}

	public function setLabel(label:String) {
		this.label.text = label;
	}

	public function setOrderNumber(orderNumber:Int) {
		this.orderNumber.text = "" + (orderNumber + 1);
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		if (icon != null) {
			icon.angle += 0.2;
		}
	}
}
