package entities;

import helpers.Constants;
import flixel.math.FlxPoint;
import spacial.Cardinal;
import depth.DepthSprite;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Player extends DepthSprite {
	var speed:Float = 30;
	var turnSpeed:Float = 90;
	var playerNum = 0;

	var dir = Cardinal.W.asVector();

	public function new(x:Float = 0, y:Float = 0, ?slicesPath:String) {
		super(x, y);
		if (slicesPath == null){
			load_slices(AssetPaths.player__png, Constants.TILE_SIZE, Constants.TILE_SIZE, 24);
		} else {
			load_slices(slicesPath, Constants.TILE_SIZE, Constants.TILE_SIZE, 24);
		}
		// test.angle = Math.random() * 360;
		// makeGraphic(20, 20, FlxColor.WHITE);
		// color = FlxColor.BLUE;
	}

	override public function update(delta:Float) {
		super.update(delta);

		// if (SimpleController.pressed(Button.DOWN)) {
		// 	velocity.set(dir.x * speed, dir.y * speed);
		// } else if (SimpleController.pressed(Button.UP)) {
		// 	velocity.set(-dir.x * speed, -dir.y * speed);
		// } else {
		// 	velocity.set();
		// }

		// if (SimpleController.pressed(Button.RIGHT)) {
		// 	dir.rotate(FlxPoint.weak(), turnSpeed * delta);
		// }

		// if (SimpleController.pressed(Button.LEFT)) {
		// 	dir.rotate(FlxPoint.weak(), -turnSpeed * delta);
		// }

		// angle = dir.degrees;

		// if (SimpleController.just_pressed(Button.A, playerNum)) {
		// 	color = color ^ 0xFFFFFF;
		// }
	}
}
