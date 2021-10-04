package states;

import haxefmod.flixel.FmodFlxUtilities;
import helpers.UiHelpers;
import flixel.ui.FlxButton;
import ui.font.BitmapText.Shadow;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 *  A FlxSubState that Fades in or out
 */
class FailSubstate extends FlxSubState {
	var _btnRetry:FlxButton;
	var _btnDone:FlxButton;

	var checkpointRoomName:String;
	/**
	 *  Creates a new substate that fades in and closes
	 *  @param time			the amount of time to fade in
	 *  @param color		a color to show in place of black
	 *  @param onFinish		function to call once fade has finished
	 */
	public function new(checkpointRoomName:String) {
		super();
		this.checkpointRoomName = checkpointRoomName;
		
        var backdrop = new FlxSprite(AssetPaths.failSplash__png);
		backdrop.setSize(FlxG.width, FlxG.height);
		backdrop.scale.scale(2);
		backdrop.updateHitbox();
        add(backdrop);

        var text = new Shadow(0, 0, "CRITICAL FAILURE");
		text.scale.scale(2);
		text.updateHitbox();
		text.setPosition(FlxG.width / 2 - text.width, text.height + 40);
		text.updateHitbox();
        add(text);

		_btnRetry = UiHelpers.createMenuButton("RETRY", handleRetry);
		_btnRetry.setPosition(FlxG.width / 2 - _btnRetry.width / 2, FlxG.height / 2 - _btnRetry.height);
		_btnRetry.updateHitbox();
		add(_btnRetry);

		_btnDone = UiHelpers.createMenuButton("Main Menu", clickMainMenu);
		_btnDone.setPosition(FlxG.width / 2 - _btnDone.width / 2, FlxG.height - _btnDone.height - 40);
		_btnDone.updateHitbox();
		add(_btnDone);
	}

	function handleRetry() {
		FmodFlxUtilities.TransitionToState(new PlayState(checkpointRoomName));
	}

	function clickMainMenu():Void {
		FmodFlxUtilities.TransitionToState(new MainMenuState());
	}
}
