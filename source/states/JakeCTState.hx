package states;

import flixel.math.FlxPoint;
import ui.camera.SetupCameras;
import depth.DepthTilemap;
import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import levels.ogmo.Level;

using extensions.FlxStateExt;

class JakeCTState extends FlxTransitionableState {
	var level:Level;

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		SetupCameras.SetupMainCamera(camera);

		var tiles = new DepthTilemap();
		tiles.x = 50;
		tiles.y = 50;
		tiles.load_slices_from_array([
			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,
			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,
			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,
			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,
			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,
			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,
			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,
			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,			1, 1, 1, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,			1, 0, 0, 1,
			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,			0, 0 ,0, 0,
		], 32, 32, [{
			graphic: AssetPaths.wall_square__png,
			slices: 18,
		}]);
		add(tiles);

		camera.zoom = 0.5;
		camera.focusOn(FlxPoint.get(tiles.x, tiles.y));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		camera.angle += 15 * elapsed;
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
