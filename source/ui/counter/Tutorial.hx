package ui.counter;

import states.PlayState;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import depth.DepthSprite;
import misc.FlxTextFactory;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.text.FlxText;

class Tutorial {
	private static var startedPushMe:Bool = false;
	private static var pushMe:Tooltip;

	public static function reset() {
		startedPushMe = false;
	}

	public static function showPushMe(x:Float, y:Float) {
		if (!startedPushMe) {
			pushMe = new Tooltip(x, y, "Push Me");
			PlayState.uiObjs.add(pushMe);
			startedPushMe = true;
		}
	}

	public static function hidePushMe() {
		if (pushMe != null) {
			PlayState.uiObjs.remove(pushMe);
			showTouchMe();
		}
	}

	private static var startedTouchMe:Bool = false;
	private static var touchMe:Tooltip;

	public static function preSetTouchMe(x:Float, y:Float) {
		if (!startedTouchMe) {
			touchMe = new Tooltip(x, y, "Touch Me");
			touchMe.visible = false;
			PlayState.uiObjs.add(touchMe);
			startedTouchMe = true;
		}
	}

	public static function showTouchMe() {
		if (touchMe != null) {
			touchMe.visible = true;
		}
	}

	public static function hideTouchMe() {
		if (touchMe != null) {
			PlayState.uiObjs.remove(touchMe);
		}
	}
}
