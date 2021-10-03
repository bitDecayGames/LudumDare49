package systems;

import helpers.Constants;
import haxe.macro.Expr.Constant;
import flixel.FlxG;
import haxe.Exception;
import entities.Player;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxBasic;
import entities.Block;
import flixel.group.FlxGroup;
import spacial.Cardinal;
import input.InputCalcuator;

class MovementSystem extends StateSystem {
	var player:Player;
	var playerCollidables:FlxTypedGroup<Block>;
	var collidables:FlxTypedGroup<FlxSprite>;

	public function new(_player:Player, _playerCollidables:FlxTypedGroup<Block>, _collidables:FlxTypedGroup<FlxSprite>) {
		super();

		player = _player;
		playerCollidables = _playerCollidables;
		collidables = _collidables;

		defaultRunningTimeDuration = Constants.PLAYER_SPEED;
		resetRunningTimeDuration();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		FlxG.watch.addQuick("Movement System run time duration", runningTimeDuration);
	}

	public function handlePlayerMovement() {
		var cardinalInput = InputCalcuator.getInputCardinal();

		if (cardinalInput != Cardinal.NONE) {
			var targetTile = ControlSystem.nextPointFromCardinal(player.getMidpoint(), cardinalInput);

			// check the blocks that could be stopping the player and find the one that is at the location of where the player is trying to move to
			var collidedBlocks = playerCollidables.members.filter(block -> block.overlapsPoint(targetTile));

			// if there's nothing in the way
			if (collidedBlocks.length == 0) {
				player.emitSmoke();
				FlxTween.linearMotion(player, player.x, player.y, targetTile.x - 8, targetTile.y - 8,
					Constants.PLAYER_SPEED); // limit player input, add more collisins
				setRunning();
			} else if (collidedBlocks.length > 1) {
				throw new Exception("Multiple collided blocks were found overlapping the same space player was moving to.");
			}
			// something is in front of the player
			else {
				var blockingBlock = collidedBlocks[0];

				// check to see if the block in the way is pushable
				if (blockingBlock.pushable) {
					// find the direction/tile that would be blocking the pushable that is blocking the player
					var targetTile2 = ControlSystem.nextPointFromCardinal(blockingBlock.getMidpoint(), cardinalInput);

					// check if there is a block in the way of the block trying to be pushed
					var collidedBlocks2 = collidables.members.filter(block -> block.overlapsPoint(targetTile2));
					if (collidedBlocks2.length == 0) {
						player.emitSmoke();
						FlxTween.linearMotion(blockingBlock, blockingBlock.x, blockingBlock.y, targetTile2.x - 8, targetTile2.y - 8, runningTimeDuration);
						FlxTween.linearMotion(player, player.x, player.y, targetTile.x - 8, targetTile.y - 8, runningTimeDuration);
						setRunning();
					}
				}
			}
		}
	}
}
