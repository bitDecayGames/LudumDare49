package entities;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class HitBox extends FlxSprite {
	public function new(width:Int, height:Int) {
		super();

        makeGraphic(width, height, FlxColor.TRANSPARENT);
	}

    override public function toString() {
        return '<HitBox x: ${x}, y: ${y}, w: ${width}, h: ${height}>';
    }
}