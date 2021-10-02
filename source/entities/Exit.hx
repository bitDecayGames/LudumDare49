package entities;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Exit extends FlxSprite {
	public static inline var OGMO_NAME = "exit";
	public final end:Bool;

	var entrance:Entrance = null;

	public function new(end:Bool) {
		super();

		makeGraphic(Constants.TILE_SIZE, Constants.TILE_SIZE, FlxColor.WHITE);
		color = FlxColor.GREEN;

		this.end = end;
	}

	public function setEntrance(value: Entrance) {
		if (entrance != null) {
			throw '${this} already has ${entrance} set';
		}
		entrance = value;
	}

	public function getEntrance() {
		return entrance;
	}

	public function validateEntrance() {
		if (end && entrance != null) {
			throw 'ending ${this} has entrance set';
		}
		if (!end && entrance == null) {
			throw '${this} does not have an entrance set';
		}
	}

	override public function update(delta:Float) {
		super.update(delta);
	}

	override public function toString() {
		return '<Exit x: ${x}, y: ${y}>';
	}
}
