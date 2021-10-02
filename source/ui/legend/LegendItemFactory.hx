package ui.legend;

import depth.DepthSprite;
import flixel.FlxSprite;

class LegendItemFactory {
	public static function FromActionStep(actionStep:ActionStep) {
		switch (actionStep) {
			case MOVEMENT:
				return Movement();
			case COOLING:
				return Cooling();
			case CONVEYOR:
				return Conveyor();
			case DECAY:
				return Decay();
			default:
				throw "Failed to find factory method for action step " + actionStep;
		}
	}

	public static function Movement():LegendItem {
		var spr = new DepthSprite(0, 0);
		spr.load_slices(AssetPaths.test__png, 16, 16, 16);
		return new LegendItem(spr, "MOVEMENT", 0);
	}

	public static function Cooling():LegendItem {
		var spr = new DepthSprite(0, 0);
		spr.load_slices(AssetPaths.test__png, 16, 16, 16);
		return new LegendItem(spr, "COOLING", 0);
	}

	public static function Conveyor():LegendItem {
		var spr = new DepthSprite(0, 0);
		spr.load_slices(AssetPaths.test__png, 16, 16, 16);
		return new LegendItem(spr, "CONVEYOR", 0);
	}

	public static function Decay():LegendItem {
		var spr = new DepthSprite(0, 0);
		spr.load_slices(AssetPaths.test__png, 16, 16, 16);
		return new LegendItem(spr, "DECAY", 0);
	}
}
