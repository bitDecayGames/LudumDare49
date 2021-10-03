package systems;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxBasic;
import entities.Block;
import flixel.group.FlxGroup;
import spacial.Cardinal;
import input.InputCalcuator;

class MovementSystem extends FlxBasic
{
    var player: FlxSprite;
    var playerCollidables:FlxTypedGroup<Block>;
    var collidables:FlxTypedGroup<FlxSprite>;

	var playerMovementLock: Float = 0;

    public function new(_player: FlxSprite,
                        _playerCollidables:FlxTypedGroup<Block>,
                        _collidables:FlxTypedGroup<FlxSprite>)
    {
        super();

        player = _player;
        playerCollidables = _playerCollidables;
        collidables = _collidables;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        // Do magical state things here

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

    public function handlePlayerMovement(elapsed:Float)
    {
        var cardinalInput = InputCalcuator.getInputCardinal();

        if(cardinalInput != Cardinal.NONE){
            
            var targetTile = ControlSystem.nextPointFromCardinal(player.getMidpoint(), cardinalInput);

            //check the blocks that could be stopping the player and find the one that is at the location of where the player is trying to move to
            var collidedBlocks = playerCollidables.members.filter(block -> block.overlapsPoint(targetTile));

            //if there's nothing in the way
            if(collidedBlocks.length == 0){
                FlxTween.linearMotion(player, player.x, player.y, targetTile.x -8 , targetTile.y -8);//limit player input, add more collisins
                ControlSystem.playerMovementLock =  1; 
            }
            else{//something is in front of the player
                var blockingBlock = collidedBlocks[0];

                //check to see if the block in the way is pushable
                if(blockingBlock.pushable){

                    //find the direction/tile that would be blocking the pushable that is blocking the player
                    var targetTile2 = ControlSystem.nextPointFromCardinal(blockingBlock.getMidpoint(), cardinalInput);

                    //check if there is a block in the way of the block trying to be pushed
                    var collidedBlocks2 = collidables.members.filter(block -> block.overlapsPoint(targetTile2));

                    if(collidedBlocks2.length == 0){// there is nothing in front of the pushable block
                        FlxTween.linearMotion(blockingBlock, blockingBlock.x, blockingBlock.y, targetTile2.x -8 , targetTile2.y -8);//push the block to the new space
                        FlxTween.linearMotion(player, player.x, player.y, targetTile.x -8 , targetTile.y -8);//move the player into the pushed blocks space
                        ControlSystem.playerMovementLock =  1; 
                    }
                }
            }
		}
    }
}