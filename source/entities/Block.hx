package entities;

import depth.DepthSprite;
import flixel.FlxSprite;
import flixel.FlxSprite.IFlxSprite;

class Block extends DepthSprite{

	public var pushable: Bool;
	public var isActive: Bool = true;

    public function new(x:Float = 0, y:Float = 0, _pushable: Bool) {
		super(x, y);
		pushable = _pushable;
	}
    
}