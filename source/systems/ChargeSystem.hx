package systems;

import haxe.Exception;
import helpers.Constants;
import spacial.Cardinal;
import flixel.math.FlxPoint;
import entities.PowerCore;
import flixel.FlxSprite;
import entities.RadioactiveCooler;
import entities.RadioactiveBlock;
import flixel.FlxBasic;
import flixel.group.FlxGroup;

class ChargeSystem extends FlxBasic{
    
    var decayingObjects:Array<RadioactiveBlock>;
    var chargingObjects:Array<PowerCore>;

    public function new(_collidables:FlxTypedGroup<FlxSprite>)
    {
        super();

        decayingObjects = _collidables.members.filter(col -> Std.isOfType(col, RadioactiveBlock)).map(col -> cast(col, RadioactiveBlock));
        chargingObjects = _collidables.members.filter(rad -> Std.isOfType(rad, PowerCore)).map(col -> cast(col, PowerCore));

    }

    override public function update(elapsed:Float) {
        handleCharge();
	}

    public function getAllCharged(): Array<PowerCore>{
        return chargingObjects.filter(c -> c.fullyCharged());
    }

    private function handleCharge(){
        for(core in chargingObjects){
            for (cardVector in Cardinal.allCardinals())
            {
                var potentialChargePoint = nextPointFromCardinal(core.getMidpoint(), cardVector);

                var matchingRadBlocks = decayingObjects.filter(rad -> rad.overlapsPoint(potentialChargePoint));
                if (matchingRadBlocks.length > 1)
                {
                    throw new Exception("Multiple radioactive blocks were found overlapping the same charging space.");
                }
                else if (matchingRadBlocks.length == 1)
                {
                    trace('Rad block and core touching');
                    core.charge(1);
                }
            }
        }
    }

    private function nextPointFromCardinal(currentPoint:FlxPoint, cardinalDir:Cardinal)
    {
        return currentPoint.addPoint(cardinalDir.asVector().scale(Constants.TILE_SIZE));
    }
    
}