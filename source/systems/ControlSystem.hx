package systems;

import haxe.Exception;
import entities.Player;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import flixel.FlxSprite;
import entities.Block;
import flixel.group.FlxGroup;
import spacial.Cardinal;
import helpers.Constants;

enum GameState {
    PlayerMovement;
    Cooling;
    Conveyors;
    Decay;
    Charging;
}

class ControlSystem extends FlxBasic
{
    var player: Player;
    var playerCollidables:FlxTypedGroup<Block>;
    var collidables:FlxTypedGroup<FlxSprite>;
    var nonCollidables:FlxTypedGroup<FlxSprite>;

    var gameState:GameState = PlayerMovement;

    var turnCycleStarted:Bool = false;

    var movementSystem:MovementSystem;
    var coolingSystem:CoolingSystem;
    var conveyorSystem:ConveyorSystem;
    var decaySystem:DecaySystem;

    public function new(_player: Player,
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
        coolingSystem.setRunningTimeDuration(0.25);
        conveyorSystem = new ConveyorSystem(player, playerCollidables, collidables, nonCollidables);
        decaySystem = new DecaySystem(collidables);
        decaySystem.setRunningTimeDuration(0);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        movementSystem.update(elapsed);
        coolingSystem.update(elapsed);
        conveyorSystem.update(elapsed);

        switch gameState {
            case PlayerMovement:

                if (movementSystem.isIdle())
                {
                    movementSystem.handlePlayerMovement();
                }
                else if (movementSystem.isDone())
                {
                    gameState = Cooling;
                }

            case Cooling:

                if (coolingSystem.isIdle())
                {
                    coolingSystem.handleCooling();
                }
                else if (coolingSystem.isDone())
                {
                    gameState = Conveyors;
                }

            case Conveyors:

                if (conveyorSystem.isIdle())
                {
                    conveyorSystem.handleConveyors();
                }
                else if (conveyorSystem.isDone())
                {
                    // gameState = Decay;
                    gameState = PlayerMovement;
                }

            case Decay:

                if (decaySystem.isIdle())
                {
                    decaySystem.handleDecay();
                }
                else if (decaySystem.isDone())
                {
                    // gameState = Charging;
                    gameState = PlayerMovement;
                }
                
            case Charging:

            default: throw new Exception("Unhandled game state");
        }
	}

    // Statics
    public static function nextPointFromCardinal(currentPoint:FlxPoint, cardinalDir:Cardinal)
    {
        return currentPoint.addPoint(cardinalDir.asVector().scale(Constants.TILE_SIZE));
    }
}