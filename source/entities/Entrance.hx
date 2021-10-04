package entities;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import helpers.Constants;

class Entrance extends FlxSprite {
	public static inline var OGMO_NAME = "entrance";

	var exit:Exit = null;

	public function new() {
		super();

		makeGraphic(Constants.TILE_SIZE, Constants.TILE_SIZE, FlxColor.WHITE);
		color = FlxColor.RED;
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
		if (exit != null) {
			throw '${this} has exit set';
		}
	}

	override public function update(delta:Float) {
		super.update(delta);
	}

	override public function toString() {
		return '<Entrance x: ${x}, y: ${y}>';
	}
}
