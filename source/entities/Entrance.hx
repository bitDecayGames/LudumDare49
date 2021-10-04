package entities;

import depth.DepthSprite;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import helpers.Constants;

class Entrance extends DepthSprite {
	public static inline var OGMO_NAME = "entrance";

	var exit:Exit = null;

	public function new() {
		super();
	
		load_slices(AssetPaths.blast_door__png, Constants.TILE_SIZE, Constants.TILE_SIZE, Constants.TILE_SIZE);
		slice_offset = 0.5;

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
