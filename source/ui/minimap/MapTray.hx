package ui.minimap;

import ui.camera.SetupCameras;
import flixel.addons.ui.FlxUI9SliceSprite;
import openfl.geom.Rectangle;

class MapTray extends FlxUI9SliceSprite {
	public function new(width:Float, height:Float, padding:Float) {
		super(0, 0, AssetPaths.tray__9__png, new Rectangle(0, 0, width + padding, height + padding), [4, 4, 12, 12]);
		var halfPadding = padding * .5;
		x -= halfPadding;
		y -= halfPadding;
	}
}
