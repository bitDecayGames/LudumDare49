import haxe.Exception;
import entities.RadioactiveBlock;
import entities.RadioactiveCooler;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import entities.Block;
import flixel.group.FlxGroup;
import entities.Player;
import flixel.tweens.FlxTween;
import spacial.Cardinal;
import input.InputCalcuator;
import helpers.Constants;

class ControlSystem extends FlxBasic
{
    var player: FlxSprite;
    var playerCollidables:FlxTypedGroup<Block>;
    var collidables:FlxTypedGroup<FlxSprite>;

	var playerMovementLock: Float = 0;

    public function new(_player: FlxSprite, _playerCollidables:FlxTypedGroup<Block>, _collidables:FlxTypedGroup<FlxSprite>)
    {
        super();

        player = _player;
        playerCollidables = _playerCollidables;
        collidables = _collidables;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (playerMovementLock == 0)
        {
            handlePlayerMovement(elapsed);
        }

        if (playerMovementLock > 0)
        {
			playerMovementLock -= elapsed;

			if(playerMovementLock < 0)
            {
                handleCooling();
                playerMovementLock = 0;
            }
		}
	}

    private function handlePlayerMovement(elapsed:Float)
    {
        var cardinalInput = InputCalcuator.getInputCardinal();

        if(cardinalInput != Cardinal.NONE){
            
            var vectorInput = cardinalInput.asVector().scale(Constants.TILE_SIZE);//maybe make tile size configurable

            var targetTile = player.getMidpoint().addPoint(vectorInput);

            //check the blocks that could be stopping the player and find the one that is at the location of where the player is trying to move to
            var collidedBlocks = playerCollidables.members.filter(block -> block.overlapsPoint(targetTile));

            //if there's nothing in the way
            if(collidedBlocks.length == 0){
                FlxTween.linearMotion(player, player.x, player.y, targetTile.x -8 , targetTile.y -8);//limit player input, add more collisins
                playerMovementLock =  1; 
            }
            else{//something is in front of the player
                var blockingBlock = collidedBlocks[0];

                //check to see if the block in the way is pushable
                if(blockingBlock.pushable){

                    //find the direction/tile that would be blocking the pushable that is blocking the player
                    var vectorInput2 = cardinalInput.asVector().scale(32);
                    var targetTile2 = player.getMidpoint().addPoint(vectorInput2);
                    //check if there is a block in the way of the block trying to be pushed
                    var collidedBlocks2 = collidables.members.filter(block -> block.overlapsPoint(targetTile2));

                    if(collidedBlocks2.length == 0){// there is nothing in front of the pushable block
                        FlxTween.linearMotion(blockingBlock, blockingBlock.x, blockingBlock.y, targetTile2.x -8 , targetTile2.y -8);//push the block to the new space
                        FlxTween.linearMotion(player, player.x, player.y, targetTile.x -8 , targetTile.y -8);//move the player into the pushed blocks space
                        playerMovementLock =  1; 
                    }

                }
            }
		}
    }

    private function handleCooling()
    {
        var coolers: Array<RadioactiveCooler> = collidables.members.filter(col -> Std.isOfType(col, RadioactiveCooler)).map(col -> cast(col, RadioactiveCooler));
        var radioactives: Array<RadioactiveBlock> = collidables.members.filter(rad -> Std.isOfType(rad, RadioactiveBlock)).map(col -> cast(col, RadioactiveBlock));

        
        var debugCooler = coolers[0];
        var debugRad = radioactives[0];

        for (cooler in coolers)
        {
            for (cardVector in Cardinal.allCardinalsVectors())
            {
                var coolTilePoint = cooler.getMidpoint().addPoint(cardVector.scale(Constants.TILE_SIZE));

                var matchingRadBlocks = radioactives.filter(rad -> rad.overlapsPoint(coolTilePoint));
                if (matchingRadBlocks.length > 1)
                {
                    throw new Exception("Multiple radioactive blocks were found overlapping the same cooling space.");
                }
                else if (matchingRadBlocks.length == 1)
                {
                    trace('Rad block and cooler overlappoing');
                    var radioactiveBlock = matchingRadBlocks[0];
                    radioactiveBlock.cool(cooler.coolingAmount);
                }
            }
        }
    }
}