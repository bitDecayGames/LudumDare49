package systems;

import flixel.math.FlxPoint;
import depth.DepthSprite;
import entities.Conveyor;
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
    var nonCollidables:FlxTypedGroup<FlxSprite>;

    public var playerIscontrollable:Bool = true;

	var playerMovementLock: Float = 0;

    public function new(_player: FlxSprite,
                        _playerCollidables:FlxTypedGroup<Block>,
                        _collidables:FlxTypedGroup<FlxSprite>,
                        _nonCollidables:FlxTypedGroup<FlxSprite>)
    {
        super();

        player = _player;
        playerCollidables = _playerCollidables;
        collidables = _collidables;
        nonCollidables = _nonCollidables;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(!playerIscontrollable) {
            return;
        }

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
                handleConveyors();
                playerMovementLock = 0;
            }
		}
	}

    private function handlePlayerMovement(elapsed:Float)
    {
        var cardinalInput = InputCalcuator.getInputCardinal();

        if(cardinalInput != Cardinal.NONE){
            
            var targetTile = nextPointFromCardinal(player.getMidpoint(), cardinalInput);

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
                    var targetTile2 = nextPointFromCardinal(blockingBlock.getMidpoint(), cardinalInput);

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

        for (cooler in coolers)
        {
            for (cardVector in Cardinal.allCardinals())
            {
                var coolTilePoint = nextPointFromCardinal(cooler.getMidpoint(), cardVector);

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

    private function handleConveyors()
    {
        var conveyors: Array<Conveyor> = nonCollidables.members.filter(nc -> Std.isOfType(nc, Conveyor)).map(nc -> cast(nc, Conveyor));
        var movables: Array<DepthSprite> = playerCollidables.members.filter(c -> c.pushable).map(c -> cast(c, DepthSprite));
        movables.push(cast(player, DepthSprite));
        
        var movementsToDo: Map<DepthSprite, FlxPoint> = new Map<DepthSprite, FlxPoint>();

        for (conv in conveyors)
        {
            var conveyorMovables = movables.filter(mov -> mov.overlapsPoint(conv.getMidpoint()));
            if (conveyorMovables.length > 1)
            {
                throw new Exception("Multiple matching movable blocks were found overlapping the same conveyor space.");
            }
            else if (conveyorMovables.length == 1)
            {
                movementsToDo.set(conveyorMovables[0], nextPointFromCardinal(conv.getMidpoint(), conv.cardFacing));
            }
        }

        var nonConveyorObjects = collidables.members.filter(o -> {
            for (conveyorObject in movementsToDo.keys())
            {
                if (o == conveyorObject) return false;
            }
            return true;
        });

        var nonConveyorPlayerCollidables = playerCollidables.members.filter(o -> {
            for (conveyorObject in movementsToDo.keys())
            {
                if (o == conveyorObject) return false;
            }
            return true;
        });

        for (conveyorMovable => targetPoint in movementsToDo)
        {
            if (player == conveyorMovable)
            {
                if (nonConveyorPlayerCollidables.filter(o -> o.overlapsPoint(targetPoint)).length > 0)
                {
                    movementsToDo[conveyorMovable] = conveyorMovable.getMidpoint();
                }
            }
            else
            {
                if (nonConveyorObjects.filter(o -> o.overlapsPoint(targetPoint)).length > 0)
                {
                    movementsToDo[conveyorMovable] = conveyorMovable.getMidpoint();
                }
            }
        }

        var movementsDuplicateValues = getMapDuplicateValues(movementsToDo);
        while (movementsDuplicateValues.length > 0)
        {
            for (duplicatePoint in movementsDuplicateValues)
            {
                resolveDuplicates(movementsToDo, duplicatePoint);
            }

            movementsDuplicateValues = getMapDuplicateValues(movementsToDo);
        }

        for (object => point in movementsToDo)
        {
            if (!object.overlapsPoint(point))
            {
                FlxTween.linearMotion(object, object.x, object.y, point.x - (Constants.TILE_SIZE / 2) , point.y - (Constants.TILE_SIZE / 2));
            }
        }
    }

    private function getMapDuplicateValues(map:Map<DepthSprite, FlxPoint>): Array<FlxPoint>
    {
        var valuesSeen: Array<FlxPoint> = new Array<FlxPoint>();
        var duplicateValues: Array<FlxPoint> = new Array<FlxPoint>();

        for(value in map)
        {
            if (valuesSeen.filter(p -> p == value).length == 1)
            {
                duplicateValues.push(value);
            }
            else
            {
                valuesSeen.push(value);
            }
        }

        return duplicateValues;
    }

    private function resolveDuplicates(map:Map<DepthSprite, FlxPoint>, duplicatePoint:FlxPoint)
    {
        for (object => point in map)
        {
            if (point == duplicatePoint)
            {
                map[object] = object.getMidpoint();
            }
        }
    }

    private function nextPointFromCardinal(currentPoint:FlxPoint, cardinalDir:Cardinal)
    {
        return currentPoint.addPoint(cardinalDir.asVector().scale(Constants.TILE_SIZE));
    }
    
}