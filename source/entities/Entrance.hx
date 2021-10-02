package entities;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import helpers.Constants;

class Entrance extends FlxSprite {
	public static inline var OGMO_NAME = "entrance";
	public final start:Bool;

	var exit:Exit = null;

	public function new(start:Bool) {
		super();

		makeGraphic(Constants.TILE_SIZE, Constants.TILE_SIZE, FlxColor.WHITE);
		color = FlxColor.RED;

		this.start = start;
	}

	public function setExit(value: Exit) {
		if (exit != null) {
			throw '${this} already has ${exit} set';
		}
		exit = value;
	}

	public function getExit() {
		return exit;
	}

	public function validateExit() {
		if (start && exit != null) {
			throw 'starting ${this} has exit set';
		}
		if (!start && exit == null) {
			throw '${this} does not have exit set';
		}
	}

	override public function update(delta:Float) {
		super.update(delta);
	}

	override public function toString() {
		return '<Entrance x: ${x}, y: ${y}>';
	}
}
