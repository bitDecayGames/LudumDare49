package systems;

import haxe.Exception;
import spacial.Cardinal;
import entities.PowerCore;
import flixel.FlxSprite;
import entities.RadioactiveBlock;
import flixel.group.FlxGroup;

class ChargeSystem extends StateSystem {
	var collidables:FlxTypedGroup<FlxSprite>;

	public function new(_collidables:FlxTypedGroup<FlxSprite>) {
		super();

		collidables = _collidables;

		defaultRunningTimeDuration = 0.25;
		resetRunningTimeDuration();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function handleCharge() {
		setRunning();

		var decayingObjects = collidables.members.filter(col -> Std.isOfType(col, RadioactiveBlock)).map(col -> cast(col, RadioactiveBlock));
		var chargingObjects = collidables.members.filter(rad -> Std.isOfType(rad, PowerCore)).map(col -> cast(col, PowerCore));

		var chargeWorkNeeded = false;
		for (core in chargingObjects) {
			for (cardVector in Cardinal.allCardinals()) {
				var potentialChargePoint = ControlSystem.nextPointFromCardinal(core.getMidpoint(), cardVector);

				var matchingRadBlocks = decayingObjects.filter(rad -> rad.overlapsPoint(potentialChargePoint));
				if (matchingRadBlocks.length > 1) {
					throw new Exception("Multiple radioactive blocks were found overlapping the same charging space.");
				} else if (matchingRadBlocks.length == 1) {
					chargeWorkNeeded = true;
					core.charge(1);
				}
			}
		}

		if (!chargeWorkNeeded)
			forciblyStopRunning();
	}

	public function getAllCharged():Array<PowerCore> {
		return collidables.members.filter(rad -> Std.isOfType(rad, PowerCore)).map(col -> cast(col, PowerCore)).filter(c -> c.fullyCharged());
	}

	public function areAllCharged() {
		var allPowerCores = collidables.members.filter(rad -> Std.isOfType(rad, PowerCore)).map(col -> cast(col, PowerCore));
		var fullyChargedPowerCores = allPowerCores.filter(c -> c.fullyCharged());

		return allPowerCores.length == fullyChargedPowerCores.length;
	}

	public function anyCoresCharged() {
		var cores = collidables.members.filter(c -> Std.isOfType(c, PowerCore)).map(c -> cast(c, PowerCore));

		var noCoresCharged = false;
		for (core in cores) {
			if (core.currentCharge > 0)
				noCoresCharged = true;
		}

		if (areAllCharged() || noCoresCharged) {
			return false;
		} else {
			return true;
		}
	}
}
