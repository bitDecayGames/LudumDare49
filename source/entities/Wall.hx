package entities;

import helpers.Constants;

class Wall extends Block {
	public static inline var OGMO_NAME = "wall";

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y, false);
		load_slices(AssetPaths.wall_square__png, Constants.TILE_SIZE, Constants.TILE_SIZE, Constants.TILE_SIZE);
		slice_offset = 0.5;
		visible = false;
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
