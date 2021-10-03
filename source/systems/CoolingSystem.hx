package systems;

import haxe.Exception;
import entities.RadioactiveBlock;
import entities.RadioactiveCooler;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import spacial.Cardinal;

class CoolingSystem extends FlxBasic
{
    var collidables:FlxTypedGroup<FlxSprite>;

    public function new(_collidables:FlxTypedGroup<FlxSprite>)
    {
        super();

        collidables = _collidables;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        // Magic state logic here

        // if (playerMovementLock == 0)
        // {
        //     movementSystem.handlePlayerMovement(elapsed);
        // }

        // if (playerMovementLock > 0)
        // {
		// 	playerMovementLock -= elapsed;

		// 	if(playerMovementLock < 0)
        //     {
        //         handleCooling();
        //         handleConveyors();
        //         playerMovementLock = 0;
        //     }
		// }
	}

    public function handleCooling()
    {
        var coolers: Array<RadioactiveCooler> = collidables.members.filter(c -> Std.isOfType(c, RadioactiveCooler)).map(c -> cast(c, RadioactiveCooler));
        var radioactives: Array<RadioactiveBlock> = collidables.members.filter(c -> Std.isOfType(c, RadioactiveBlock)).map(c -> cast(c, RadioactiveBlock));

        for (cooler in coolers)
        {
            for (cardVector in Cardinal.allCardinals())
            {
                var coolTilePoint = ControlSystem.nextPointFromCardinal(cooler.getMidpoint(), cardVector);

                var matchingRadBlocks = radioactives.filter(rad -> rad.overlapsPoint(coolTilePoint));
                if (matchingRadBlocks.length > 1)
                {
                    throw new Exception("Multiple radioactive blocks were found overlapping the same cooling space.");
                }
                else if (matchingRadBlocks.length == 1)
                {
                    var radioactiveBlock = matchingRadBlocks[0];
                    radioactiveBlock.cool(cooler.coolingAmount);
                }
            }
        }
    }   
}