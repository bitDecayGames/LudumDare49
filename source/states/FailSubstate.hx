package states;

import ui.font.BitmapText.Shadow;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 *  A FlxSubState that Fades in or out
 */
class FailSubstate extends FlxSubState {
	/**
	 *  Creates a new substate that fades in and closes
	 *  @param time			the amount of time to fade in
	 *  @param color		a color to show in place of black
	 *  @param onFinish		function to call once fade has finished
	 */
	public function new() {
		super();
		
        var backdrop = new FlxSprite(AssetPaths.failSplash__png);
        backdrop.setSize(FlxG.width, FlxG.height);
        add(backdrop);

        var text = new Shadow(0, 0, "TOXIC WASTED");
        add(text);

	}
}
