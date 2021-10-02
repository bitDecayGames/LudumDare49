package ui.camera;

import shaders.Silhouette;
import flixel.math.FlxPoint;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.system.FlxAssets.FlxShader;

class SetupCameras {
	public static function SetupMainCamera(camera:FlxCamera) {
		camera.bgColor = FlxColor.GRAY;

		FlxG.camera.pixelPerfectRender = true;

		// make our camera fill the screen even when rotated
		var ogWidth = FlxG.width;
		var ogHeight = FlxG.height;
		FlxG.camera.width = Std.int(Math.sqrt(Math.pow(FlxG.width, 2) + Math.pow(FlxG.height, 2)));
		FlxG.camera.height = camera.width;
		FlxG.camera.x = (FlxG.camera.width - ogWidth) / -2;
		FlxG.camera.y = (FlxG.camera.height - ogHeight) / -2;
		FlxG.cameras.setDefaultDrawTarget(FlxG.camera, true);

		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
	}

	public static var uiCamera:FlxCamera;

	public static function SetupUICamera() {
		uiCamera = new FlxCamera();
		uiCamera.scroll = FlxPoint.get(0, 0);
		uiCamera.setSize(FlxG.width, FlxG.height);
		uiCamera.bgColor = FlxColor.TRANSPARENT;
		uiCamera.pixelPerfectRender = true;
		FlxG.cameras.add(uiCamera);
		FlxG.cameras.setDefaultDrawTarget(uiCamera, false);
	}

	public static var minimapCamera:FlxCamera;
	private static var minimapZoomFactor:Float = 0.3;

	public static function SetupMiniMapCamera(x:Float, y:Float, width:Int, height:Int) {
		minimapCamera = new FlxCamera();
		minimapCamera.setPosition(x, y);
		minimapCamera.setSize(width, height);
		minimapCamera.scroll = FlxPoint.get(0, 0);
		minimapCamera.bgColor = FlxColor.TRANSPARENT;
		minimapCamera.setScale(minimapZoomFactor, minimapZoomFactor);
		minimapCamera.pixelPerfectRender = true;
		minimapCamera.setFilters([new ShaderFilter(new Silhouette())]);
		FlxG.cameras.add(minimapCamera);
		FlxG.cameras.setDefaultDrawTarget(minimapCamera, true);
	}
}
