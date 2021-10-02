package entities;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Exit extends FlxSprite {
	public static inline var OGMO_NAME = "exit";
	public final end:Bool;

	var entrance:Entrance;

	public function new(end:Bool) {
		super();

		makeGraphic(16, 16, FlxColor.WHITE);
		color = FlxColor.GREEN;

		this.end = end;
	}

	function getXYStr() {
		return '(x: ${x}, y: ${y})';
	}

	public function setEntrance(entrance: Entrance) {
		if (entrance != null) {
			throw 'exit at ${getXYStr()} already has entrance set';
		}
		this.entrance = entrance;
	}

	public function getEntrance() {
		return entrance;
	}

	public function validateEntrance() {
		if (end && entrance != null) {
			throw 'ending exit at ${getXYStr()} has entrance set';
		}
		if (!end && entrance == null) {
			throw 'exit at ${getXYStr()} does not have an entrance set';
		}
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
