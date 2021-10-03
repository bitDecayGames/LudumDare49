package helpers;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;

class SimpleDepthSprite extends FlxSprite {
	/**
	 * All DepthSprites in this list.
	 */
	public var slices:Array<SimpleDepthSprite> = [];

	/**
	 * Simulated position of the sprite on the Z axis.
	 */
	public var z:Float = 0.0;

	public var local_x:Float = 0.0;

	public var local_y:Float = 0.0;

	/**
	 * Simulated position of the sprite on the Z axis, relative to the sprite's parent
	 */
	public var local_z:Float = 0.0;

	public var local_angle:Float = 0.0;

	public var velocity_z:Float = 0.0;

	/**
	 * Offset of each 3D "Slice"
	 */
	public var slice_offset:Float = 1;

	/**
	 * Amount of Graphics in this list.
	 */
	public var count(get, never):Int;

	var parent_red:Float = 1;
	var parent_green:Float = 1;
	var parent_blue:Float = 1;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		z = 0;
		velocity_z = 0;
	}

	/**
	 * Loads a 3D Sprite from a Sprite sheet
	 * @param img
	 	  * @param width
	 * @param height
	 * @param slices
	 */
	public function load_slices(img:FlxGraphicAsset, width:Int, height:Int, slices:Int):SimpleDepthSprite {
		this.slices.resize(0);
		// loadGraphic(img, true, slice_width, slice_height);
		makeGraphic(width, height, FlxColor.TRANSPARENT);
		for (i in 0...slices)
			load_slice(img, width, height, i, i);

		return this;
	}

	inline function load_slice(img:FlxGraphicAsset, width:Int, height:Int, z:Int, frame:Int = 0) {
		var s = get_slice(z);
		s.loadGraphic(img, true, width, height);
		s.animation.frameIndex = frame;
	}

	inline function get_slice(z:Int):SimpleDepthSprite {
		var s = new SimpleDepthSprite(x, y);
		s.local_z = -z;
		s.z = this.z + s.local_z;
		s.solid = false;
		s.camera = camera;
		#if FLX_DEBUG
		s.ignoreDrawDebug = true;
		#end
		add_slice(s);
		return s;
	}

	/**
	 * Adds the DepthSprite to the slices list.
	 *
	 * @param	slice	The DepthSprite to add.
	 * @return	The added DepthSprite.
	 */
	public function add_slice(slice:SimpleDepthSprite):SimpleDepthSprite {
		if (slices.indexOf(slice) >= 0)
			return slice;

		slices.push(slice);
		slice.velocity.set(0, 0);
		slice.acceleration.set(0, 0);
		slice.scrollFactor.copyFrom(scrollFactor);

		slice.alpha = alpha;
		slice.parent_red = color.redFloat;
		slice.parent_green = color.greenFloat;
		slice.parent_blue = color.blueFloat;
		slice.color = slice.color;

		return slice;
	}

	inline function get_count():Int {
		return slices.length;
	}

	override public function draw():Void {
		super.draw();

		for (slice in slices)
			if (slice.exists && slice.visible)
				slice.draw();
	}

	public function sync() {
		for (slice in slices)
			if (slice.active && slice.exists) {
				slice.x = slice.local_x + x;
				slice.y = slice.local_y + y;
				slice.z = slice.local_z * slice_offset + z;
				slice.angle = slice.local_angle + angle;
				slice.scale.copyFrom(scale);

				slice.sync();
			}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		z += velocity_z * elapsed;

		for (slice in slices)
			if (slice.active && slice.exists)
				slice.update(elapsed);

		sync();
	}
}
