package ui.minimap;

import ui.camera.SetupCameras;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import ui.minimap.MapTray;
import signals.UI;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

class MiniMap extends FlxSpriteGroup {
	private static var minimapWidth:Int = 100;
	private static var minimapHeight:Int = 100;
	private static var padding:Int = 4;

	private var tray:MapTray;

	public var minimapCamera:FlxCamera;

	public function new() {
		super();
		var halfPadding = Std.int(padding / 2);
		x = halfPadding;
		y = halfPadding;
		if (SetupCameras.uiCamera == null) {
			SetupCameras.SetupUICamera();
		}
		camera = SetupCameras.uiCamera;
		cameras = [camera];

		tray = new MapTray(minimapWidth, minimapHeight, padding);
		add(tray);
		SetupCameras.SetupMiniMapCamera(x, y, minimapWidth, minimapHeight);
	}
}
