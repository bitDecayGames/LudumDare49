package systems;

import flixel.FlxG;
import entities.FastForward;
import signals.UI;
import ui.legend.ActionStep;
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

class ControlSystem extends FlxBasic {
	var player:Player;
	var playerCollidables:FlxTypedGroup<Block>;
	var collidables:FlxTypedGroup<FlxSprite>;
	var nonCollidables:FlxTypedGroup<FlxSprite>;

    public var playerIscontrollable = true;
	
	var gameState:GameState = PlayerMovement;

	var fastForwardStarted:Bool = false;

	var movementSystem:MovementSystem;
	var coolingSystem:CoolingSystem;
	var conveyorSystem:ConveyorSystem;
	var decaySystem:DecaySystem;
	var chargeSystem:ChargeSystem;

	public function new(_player:Player, _playerCollidables:FlxTypedGroup<Block>, _collidables:FlxTypedGroup<FlxSprite>,
			_nonCollidables:FlxTypedGroup<FlxSprite>) {
		super();

		player = _player;
		playerCollidables = _playerCollidables;
		collidables = _collidables;
		nonCollidables = _nonCollidables;

		movementSystem = new MovementSystem(player, playerCollidables, collidables);
		coolingSystem = new CoolingSystem(collidables);
		conveyorSystem = new ConveyorSystem(player, playerCollidables, collidables, nonCollidables);
		decaySystem = new DecaySystem(collidables);
		chargeSystem = new ChargeSystem(collidables);

		UI.highlightActionStep.dispatch(ActionStep.MOVEMENT);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		movementSystem.update(elapsed);
		coolingSystem.update(elapsed);
		conveyorSystem.update(elapsed);
		decaySystem.update(elapsed);
		chargeSystem.update(elapsed);

		switch gameState {
			case PlayerMovement:
				if (playerOnFastForward() && chargeSystem.anyCoresCharged()) {
					if (!fastForwardStarted) {
						setFastForwardSystemRuntimes(Constants.FF_SPEED);
						fastForwardStarted = true;
					}
					movementSystem.handlePlayerMovement();
					gameState = Cooling;
				} else if (movementSystem.isIdle()) {
					if (fastForwardStarted) {
						fastForwardStarted = false;
						resetSystemRuntimes();
					}
					movementSystem.handlePlayerMovement();
				} else if (movementSystem.isDone()) {
					movementSystem.setIdle();
					gameState = Cooling;
				}

			case Cooling:
				if (coolingSystem.isIdle()) {
					UI.highlightActionStep.dispatch(ActionStep.COOLING);
					coolingSystem.handleCooling();
				} else if (coolingSystem.isDone()) {
					coolingSystem.setIdle();
					gameState = Conveyors;
				}

			case Conveyors:
				if (conveyorSystem.isIdle()) {
					UI.highlightActionStep.dispatch(ActionStep.CONVEYOR);
					conveyorSystem.handleConveyors();
				} else if (conveyorSystem.isDone()) {
					conveyorSystem.setIdle();
					gameState = Decay;
				}

			case Decay:
				if (decaySystem.isIdle()) {
					UI.highlightActionStep.dispatch(ActionStep.DECAY);
					decaySystem.handleDecay();
				} else if (decaySystem.isDone()) {
					decaySystem.setIdle();
					gameState = Charging;
				}

			case Charging:
				if (chargeSystem.isIdle()) {
					chargeSystem.handleCharge();
				} else if (chargeSystem.isDone()) {
					chargeSystem.setIdle();
					gameState = PlayerMovement;
					UI.highlightActionStep.dispatch(ActionStep.MOVEMENT);
				}

			default:
				throw new Exception("Unhandled game state.");
		}
	}

	private function resetSystemRuntimes() {
		coolingSystem.resetRunningTimeDuration();
		conveyorSystem.resetRunningTimeDuration();
		decaySystem.resetRunningTimeDuration();
		chargeSystem.resetRunningTimeDuration();
	}

	private function setFastForwardSystemRuntimes(percent:Float) {
		coolingSystem.setRunningTimeDurationPercent(percent);
		conveyorSystem.setRunningTimeDurationPercent(percent);
		decaySystem.setRunningTimeDurationPercent(percent);
		chargeSystem.setRunningTimeDurationPercent(percent);
	}

	private function playerOnFastForward() {
		var fastForwardTiles = collidables.members.filter(c -> Std.isOfType(c, FastForward));

		for (ffTile in fastForwardTiles) {
			return player.overlapsPoint(ffTile.getMidpoint());
		}

		return false;
	}

	// Statics
	public static function nextPointFromCardinal(currentPoint:FlxPoint, cardinalDir:Cardinal) {
		return currentPoint.addPoint(cardinalDir.asVector().scale(Constants.TILE_SIZE));
	}
}
