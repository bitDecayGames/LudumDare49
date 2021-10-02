package entities;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Entrance extends FlxSprite {
	public static inline var OGMO_NAME = "entrance";
	public final start:Bool;

	var exit:Exit;

	public function new(start:Bool) {
		super();

		makeGraphic(16, 16, FlxColor.WHITE);
		color = FlxColor.RED;

		this.start = start;
	}

	function getXYStr() {
		return '(x: ${x}, y: ${y})';
	}

	public function setExit(exit: Exit) {
		if (exit != null) {
			throw 'entrance at ${getXYStr()} already has exit set';
		}
		this.exit = exit;
	}

	public function getExit() {
		return exit;
	}

	public function validateExit() {
		if (start && exit != null) {
			throw 'starting entrance at ${getXYStr()} has exit set';
		}
		if (!start && exit == null) {
			throw 'entrance at ${getXYStr()} does not have exit set';
		}
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
