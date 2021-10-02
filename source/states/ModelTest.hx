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
        add(model);
        var define = Macros.getDefine("obj");
        var modelName = define.substr(0, Std.int(define.length / 2));
        trace(modelName);
        switch(modelName) {
            case "cooler":
                model.load_slices(AssetPaths.cooler_block__png, 16, 16, 16);
                model.slice_offset = 0.5;
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
        }

        if (FlxG.keys.pressed.D) {
            camera.angle -=  30 * elapsed;
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