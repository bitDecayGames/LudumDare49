package;

import states.SplashScreenState;
import misc.Macros;
import states.MainMenuState;
import states.JakeCTState;
import flixel.FlxState;
import config.Configure;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import misc.FlxTextFactory;
import openfl.display.Sprite;
#if play
import states.PlayState;
#end
#if logan
import states.LoganState;
#elseif tanner
import states.TannerState;
#end

#if model
import states.ModelTest;
#end

class Main extends Sprite {
	public function new() {
		super();
		Configure.initAnalytics(false);

		var startingState:Class<FlxState> = SplashScreenState;
		#if play
		startingState = PlayState;
		#elseif jakect
		startingState = JakeCTState;
		#else
		if (Macros.isDefined("SKIP_SPLASH")) {
			startingState = MainMenuState;
		}
		#end

		#if logan
		startingState = LoganState;
		#elseif tanner
		startingState = TannerState;
		#end

		#if model
		startingState = ModelTest;
		#end

		addChild(new FlxGame(Std.int(640 / 1), Std.int(480 / 1), startingState, 1, 60, 60, true, false));

		FlxG.fixedTimestep = false;

		// Disable flixel volume controls as we don't use them because of FMOD
		FlxG.sound.muteKeys = null;
		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;

		// Don't use the flixel cursor
		FlxG.mouse.useSystemCursor = true;

		#if debug
		FlxG.autoPause = false;
		#end

		// Set up basic transitions. To override these see `transOut` and `transIn` on any FlxTransitionable states
		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.35);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.35);

		FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
		FlxTextFactory.defaultSize = 10;
	}
}
