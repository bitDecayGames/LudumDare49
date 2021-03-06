package entities;

import depth.DepthSprite;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import helpers.Constants;

class Exit extends Block {
	public static inline var OGMO_NAME = "exit";
	public final end:Bool = false;
	public final nextRoom:String = "FILL_ME";

	var entrance:Entrance = null;

	public function new(end:Bool, nextRoom:String) {
		super(false);

		load_slices(AssetPaths.blast_door__png, Constants.TILE_SIZE, Constants.TILE_SIZE, Constants.TILE_SIZE);
		slice_offset = 0.5;
		this.end = end;
		this.nextRoom = nextRoom;

		width = 10;
		height = 10;
		
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
