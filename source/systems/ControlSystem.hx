package systems;

import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxSprite;
import entities.Block;
import flixel.group.FlxGroup;
import spacial.Cardinal;
import helpers.Constants;

class ControlSystem extends FlxBasic
{
    var player: FlxSprite;
    var playerCollidables:FlxTypedGroup<Block>;
    var collidables:FlxTypedGroup<FlxSprite>;
    var nonCollidables:FlxTypedGroup<FlxSprite>;

    public var playerIscontrollable:Bool = true;
    
    // TODO CHANGE THIS!!!!!
	public static var playerMovementLock: Float = 0;

    var movementSystem:MovementSystem;
    var coolingSystem:CoolingSystem;
    var conveyorSystem:ConveyorSystem;

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

        movementSystem = new MovementSystem(player, playerCollidables, collidables);
        coolingSystem = new CoolingSystem(collidables);
        conveyorSystem = new ConveyorSystem(player, playerCollidables, collidables, nonCollidables);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(!playerIscontrollable) {
            return;
        }

        if (playerMovementLock == 0)
        {
            movementSystem.handlePlayerMovement(elapsed);
        }

        if (playerMovementLock > 0)
        {
			playerMovementLock -= elapsed;

			if (playerMovementLock < 0)
            {
                coolingSystem.handleCooling();
                conveyorSystem.handleConveyors();
                playerMovementLock = 0;
            }
		}
	}

    // Statics
    public static function nextPointFromCardinal(currentPoint:FlxPoint, cardinalDir:Cardinal)
    {
        return currentPoint.addPoint(cardinalDir.asVector().scale(Constants.TILE_SIZE));
    }
}