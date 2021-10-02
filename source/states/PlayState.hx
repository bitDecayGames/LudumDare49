package states;

import spacial.Cardinal;
import flixel.tweens.FlxTween;
import input.InputCalcuator;
import input.SimpleController;
import entities.Wall;
import entities.Blocks;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.util.FlxColor;
import depth.DepthSprite;
import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import entities.Player;
import flixel.FlxSprite;
import flixel.FlxG;

using extensions.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var player:FlxSprite;
	var playerMovementLock: Float = 0;

	var test:DepthSprite;

	var playerCollidables:FlxTypedGroup<Blocks> = new FlxTypedGroup();
	var collidables:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		camera.bgColor = FlxColor.GRAY;

		FlxG.camera.pixelPerfectRender = true;

		var wall = new Wall(66,50);
		collidables.add(wall);
		playerCollidables.add(wall);
		player = new Player(50, 50);
		add(player);

		// test = new DepthSprite(32, 32);
		// test.load_slices(AssetPaths.test__png, 16, 16, 16);
		// test.angle = Math.random() * 360;
		// test.slice_offset = 0.5;
		add(collidables);
		add(playerCollidables);
		add(test);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		// test.angle +=  30 * elapsed;
		// camera.angle +=  15 * elapsed;

		if(playerMovementLock == 0){
			if(SimpleController.just_pressed(Button.RIGHT)){

			}

			var cardinalInput = InputCalcuator.getInputCardinal();
			FlxG.watch.addQuick("the mofo input: ",cardinalInput);
			if(cardinalInput != Cardinal.NONE){
				var vectorInput = cardinalInput.asVector().scale(16);//maybe make tile size configurable

				var targetTile = player.getMidpoint().addPoint(vectorInput);
				FlxG.watch.addQuick("the mofo tile: ",targetTile);

				//check the blocks that could be stopping the player and find the one that is at the location of where the player is trying to move to
				var collidedBlocks = playerCollidables.members.filter(block -> block.overlapsPoint(targetTile));

				//if there's nothing in the way
				if(collidedBlocks.length == 0 ){
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

						if(collidedBlocks2.length == 0 && playerMovementLock == 0){// there is nothing in front of the pushable block
							FlxTween.linearMotion(blockingBlock, blockingBlock.x, blockingBlock.y, targetTile2.x -8 , targetTile2.y -8);//push the block to the new space
							FlxTween.linearMotion(player, player.x, player.y, targetTile.x -8 , targetTile.y -8);//move the player into the pushed blocks space
							playerMovementLock =  1; 
						}

					}
				}

			}

		}
		if(playerMovementLock >0){
			playerMovementLock -= elapsed;
			if(playerMovementLock <0) playerMovementLock = 0;
		}
		FlxG.watch.addQuick("the lock: ",playerMovementLock);

	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
