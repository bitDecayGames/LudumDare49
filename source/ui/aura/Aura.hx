package ui.aura;

import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import js.html.svg.ZoomAndPan;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import helpers.Constants;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.text.FlxText;

class Aura extends FlxSprite {

    private var followOffset:FlxPoint;

	private var follow:FlxObject;
    private var isSet: Bool = false;

	public function new(x:Float, y:Float, color:FlxColor, off:FlxPoint) {
		super(x, y);
        loadGraphic(AssetPaths.circle__png);
        alpha = 0.20;
        FlxTween.tween(this, {
            alpha: 0.05
        }, {
            type: FlxTweenType.PINGPONG
        } );
        followOffset = off;
        this.color = color;
	}

	public function setFollow(obj:FlxObject):Aura {
		follow = obj;
		return this;
	}

	public override function update(elapsed:Float) {
        if (follow != null) {
			x = follow.x + followOffset.x;
			y = follow.y + followOffset.y;
			angle = 360 - camera.angle;
		}
	}
}
