package systems;

import haxe.Exception;
import spacial.Cardinal;
import entities.PowerCore;
import flixel.FlxSprite;
import entities.RadioactiveBlock;
import flixel.group.FlxGroup;

class ChargeSystem extends StateSystem{
    
    var collidables:FlxTypedGroup<FlxSprite>;

    public function new(_collidables:FlxTypedGroup<FlxSprite>)
    {
        super();

        collidables = _collidables;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
	}

    public function handleCharge()
    {
        setRunning();

        var decayingObjects = collidables.members.filter(col -> Std.isOfType(col, RadioactiveBlock)).map(col -> cast(col, RadioactiveBlock));
        var chargingObjects = collidables.members.filter(rad -> Std.isOfType(rad, PowerCore)).map(col -> cast(col, PowerCore));

        var chargeWorkNeeded = false;
        for(core in chargingObjects)
        {
            for (cardVector in Cardinal.allCardinals())
            {
                var potentialChargePoint = ControlSystem.nextPointFromCardinal(core.getMidpoint(), cardVector);

                var matchingRadBlocks = decayingObjects.filter(rad -> rad.overlapsPoint(potentialChargePoint));
                if (matchingRadBlocks.length > 1)
                {
                    throw new Exception("Multiple radioactive blocks were found overlapping the same charging space.");
                }
                else if (matchingRadBlocks.length == 1)
                {
                    chargeWorkNeeded = true;
                    core.charge(1);
                }
            }
        }

        if (!chargeWorkNeeded) forciblyStopRunning();
    }

    public function getAllCharged(): Array<PowerCore>{
        return collidables.members.filter(rad -> Std.isOfType(rad, PowerCore)).map(col -> cast(col, PowerCore)).filter(c -> c.fullyCharged());
    }
}