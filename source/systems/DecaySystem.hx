package systems;

import helpers.Constants;
import haxe.macro.Expr.Constant;
import flixel.FlxG;
import flixel.FlxSprite;
import entities.RadioactiveBlock;
import flixel.group.FlxGroup;

class DecaySystem extends StateSystem {
	var collidables:FlxTypedGroup<FlxSprite>;

	public function new(_collidables:FlxTypedGroup<FlxSprite>) {
		super();

		collidables = _collidables;

		defaultRunningTimeDuration = Constants.DECAY_SYSTEM_DEFAULT_RUNTIME;
		resetRunningTimeDuration();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function handleDecay() {
		setRunning();

		var decayWorkNeeded = false;
		for (reactor in collidables.members.filter(col -> Std.isOfType(col, RadioactiveBlock)).map(col -> cast(col, RadioactiveBlock))) {
			decayWorkNeeded = true;
			reactor.decay();
		}

		if (!decayWorkNeeded)
			forciblyStopRunning();
	}

	public function getAllMeltdowns():Array<RadioactiveBlock> {
		return collidables.members.filter(col -> Std.isOfType(col, RadioactiveBlock)).map(col -> cast(col, RadioactiveBlock)).filter(d -> d.meltedDown());
	}

	public function isCritical() {
		return collidables.members
			.filter(col -> Std.isOfType(col, RadioactiveBlock))
			.map(col -> cast(col, RadioactiveBlock))
			.filter(d -> d.isCritical())
			.length > 0;
	}

	public function anyMeltdowns(): Bool{
		return getAllMeltdowns().length > 0;
	}
}
