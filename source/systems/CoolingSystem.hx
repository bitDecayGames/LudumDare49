package systems;

import helpers.Constants;
import flixel.FlxG;
import haxe.Exception;
import entities.RadioactiveBlock;
import entities.RadioactiveCooler;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import spacial.Cardinal;

class CoolingSystem extends StateSystem {
	var collidables:FlxTypedGroup<FlxSprite>;

	public function new(_collidables:FlxTypedGroup<FlxSprite>) {
		super();

		collidables = _collidables;

		defaultRunningTimeDuration = Constants.COOLING_SYSTEM_DEFAULT_RUNTIME;
		resetRunningTimeDuration();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function handleCooling() {
		setRunning();

		var coolers:Array<RadioactiveCooler> = collidables.members.filter(c -> Std.isOfType(c, RadioactiveCooler)).map(c -> cast(c, RadioactiveCooler));
		var radioactives:Array<RadioactiveBlock> = collidables.members.filter(c -> Std.isOfType(c, RadioactiveBlock)).map(c -> cast(c, RadioactiveBlock));

		var coolingWorkNeeded = false;
		for (cooler in coolers) {
			for (cardVector in Cardinal.allCardinals()) {
				var coolTilePoint = ControlSystem.nextPointFromCardinal(cooler.getMidpoint(), cardVector);

				var matchingRadBlocks = radioactives.filter(rad -> rad.overlapsPoint(coolTilePoint));
				if (matchingRadBlocks.length > 1) {
					throw new Exception("Multiple radioactive blocks were found overlapping the same cooling space.");
				} else if (matchingRadBlocks.length == 1) {
					var radioactiveBlock = matchingRadBlocks[0];
					radioactiveBlock.cool(cooler.coolingAmount);
					coolingWorkNeeded = true;
				}
			}
		}

		if (!coolingWorkNeeded)
			forciblyStopRunning();
	}
}
