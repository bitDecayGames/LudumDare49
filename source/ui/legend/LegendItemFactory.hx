package ui.legend;

import ui.camera.SetupCameras;
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
			case CHARGE:
				return Charge();
			default:
				throw "Failed to find factory method for action step " + actionStep;
		}
	}

	public static function Movement():LegendItem {
		var spr = new DepthSprite(0, 0);
		if (SetupCameras.uiCamera != null) {
			spr.camera = SetupCameras.uiCamera;
			spr.cameras = [SetupCameras.uiCamera];
		}
		spr.load_slices(AssetPaths.player__png, 16, 16, 16);
		return new LegendItem(spr, "MOVEMENT", 0);
	}

	public static function Cooling():LegendItem {
		var spr = new DepthSprite(0, 0);
		if (SetupCameras.uiCamera != null) {
			spr.camera = SetupCameras.uiCamera;
			spr.cameras = [SetupCameras.uiCamera];
		}
		spr.load_slices(AssetPaths.cooler_block__png, 16, 16, 16);
		return new LegendItem(spr, "COOLING", 0);
	}

	public static function Conveyor():LegendItem {
		var spr = new DepthSprite(0, 0);
		if (SetupCameras.uiCamera != null) {
			spr.camera = SetupCameras.uiCamera;
			spr.cameras = [SetupCameras.uiCamera];
		}
		spr.load_slices(AssetPaths.conveyor__png, 16, 16, 16);
		return new LegendItem(spr, "CONVEYOR", 0);
	}

	public static function Decay():LegendItem {
		var spr = new DepthSprite(0, 0);
		if (SetupCameras.uiCamera != null) {
			spr.camera = SetupCameras.uiCamera;
			spr.cameras = [SetupCameras.uiCamera];
		}
		spr.load_slices(AssetPaths.nuke__png, 16, 16, 16);
		return new LegendItem(spr, "DECAY", 0);
	}

	public static function Charge():LegendItem {
		var spr = new DepthSprite(0, 0);
		if (SetupCameras.uiCamera != null) {
			spr.camera = SetupCameras.uiCamera;
			spr.cameras = [SetupCameras.uiCamera];
		}
		spr.load_slices(AssetPaths.battery__png, 16, 16, 16);
		return new LegendItem(spr, "CHARGE", 0);
	}
}
