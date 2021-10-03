package states;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
import misc.Macros;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import depth.DepthUtil;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.util.FlxColor;
import depth.DepthSprite;
import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import entities.Player;
import flixel.FlxSprite;
import flixel.FlxG;

using extensions.FlxStateExt;

class ModelTest extends FlxState {

    var model:DepthSprite;
    var exploded = false;

    var bgColorIndex = 0;
    var bgColors = [
        FlxColor.GRAY,
        FlxColor.MAGENTA,
        FlxColor.BLACK,
        FlxColor.WHITE,
        FlxColor.YELLOW
    ];

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

        FlxG.debugger.visible = true;

		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;

		FlxG.camera.pixelPerfectRender = true;
        FlxG.camera.zoom = 3;

        model = new DepthSprite(FlxG.width / 2 - 8, FlxG.height / 2 - 8);
        model.slice_offset = 0.5;

        add(model);
        var define = Macros.getDefine("obj");
        var modelName = define.substr(0, Std.int(define.length / 2));
        trace(modelName);
        switch(modelName) {
            case "battery":
                model.load_slices(AssetPaths.battery__png, 16, 16, 16);
                model.slice_offset = 1;
                FlxTween.tween(model, {slice_offset: 1.5}, 3, 
                    {
                        type: FlxTweenType.PINGPONG,
                        ease: FlxEase.quadInOut
                    });
            case "player":
                model.load_slices(AssetPaths.player__png, 16, 16, 24);
            case "cooler":
                model.load_slices(AssetPaths.cooler_block__png, 16, 16, 16);
            case "nuke":
                model.load_slices(AssetPaths.nuke__png, 16, 16, 16);
            case "crate":
                model.load_slices(AssetPaths.crate__png, 16, 16, 16);
            case "wall_round":
                model.load_slices(AssetPaths.wall_round__png, 16, 16, 16);
            case "wall_square":
                model.load_slices(AssetPaths.wall_square__png, 16, 16, 16);
            case "smoke":
                model.load_slices(AssetPaths.smoke__png, 8, 8, 4);
            default:
        }

        FlxG.watch.add(model, "slice_offset", "Depth: ");
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

        if (FlxG.keys.justPressed.Q) {
            bgColorIndex = FlxMath.wrap(bgColorIndex + 1, 0, bgColors.length - 1);
        }
		camera.bgColor = bgColors[bgColorIndex];


		// camera.angle +=  15 * elapsed;

        if (FlxG.keys.justPressed.E) {
            exploded = !exploded;
            var target = exploded ? 6 : 1;
            FlxTween.tween(model, { "slice_offset": target }, {
                ease: FlxEase.quadOut
            });
        }

        if (FlxG.keys.justPressed.W) {
            model.slice_offset += .1;
        }

        if (FlxG.keys.justPressed.S) {
            model.slice_offset -= .1;
        }

        if (FlxG.keys.pressed.A) {
            camera.angle +=  30 * elapsed;
            // model.z +=  30 * elapsed;
        }

        if (FlxG.keys.pressed.D) {
            camera.angle -=  30 * elapsed;
            // model.z -=  30 * elapsed;
        }

        if (FlxG.keys.pressed.B) {
            model.load_slices(AssetPaths.player_off__png, 16, 16, 24);
        }
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
