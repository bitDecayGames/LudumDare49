package systems;

import flixel.FlxG;
import flixel.FlxObject;
import js.html.TableElement;
import flixel.math.FlxPoint;
import depth.DepthSprite;
import entities.Conveyor;
import haxe.Exception;
import flixel.FlxBasic;
import flixel.FlxSprite;
import entities.Block;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import helpers.Constants;

class ConveyorSystem extends StateSystem {
	var player:FlxSprite;
	var playerCollidables:FlxTypedGroup<Block>;
	var collidables:FlxTypedGroup<FlxSprite>;
	var nonCollidables:FlxTypedGroup<FlxSprite>;

	public function new(_player:FlxSprite, _playerCollidables:FlxTypedGroup<Block>, _collidables:FlxTypedGroup<FlxSprite>,
			_nonCollidables:FlxTypedGroup<FlxSprite>) {
		super();

		player = _player;
		playerCollidables = _playerCollidables;
		collidables = _collidables;
		nonCollidables = _nonCollidables;

		defaultRunningTimeDuration = Constants.CONVEYOR_SYSTEM_DEFAULT_RUNTIME;
		resetRunningTimeDuration();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function handleConveyors() {
		setRunning();

		var conveyors:Array<Conveyor> = nonCollidables.members.filter(n -> Std.isOfType(n, Conveyor)).map(n -> cast(n, Conveyor));
		var movables:Array<DepthSprite> = playerCollidables.members.filter(p -> p.pushable).map(p -> cast(p, DepthSprite));
		movables.push(cast(player, DepthSprite));

		// Map movable objects on the conveyors to their desired location
		var conveyorMovableToDesiredPoint:Map<DepthSprite, FlxPoint> = new Map<DepthSprite, FlxPoint>();
		for (conveyor in conveyors) {
			var conveyorMovables = movables.filter(m -> m.overlapsPoint(conveyor.getMidpoint()));

			if (conveyorMovables.length > 1) {
				throw new Exception("Multiple matching movable blocks were found overlapping the same conveyor space.");
			} else if (conveyorMovables.length == 1) {
				conveyorMovableToDesiredPoint.set(conveyorMovables[0], ControlSystem.nextPointFromCardinal(conveyor.getMidpoint(), conveyor.cardFacing));
			}
		}

		// Get all collidable objets that are not on top of conveyors
		var nonConveyorObjects = collidables.members.filter(c -> isNotWithinMapKey(c, conveyorMovableToDesiredPoint));

		// Get all player collidable objects that are not on top of conveyors
		var nonConveyorPlayerCollidables = playerCollidables.members.filter(p -> isNotWithinMapKey(p, conveyorMovableToDesiredPoint));

		// Resolve objects on conveyors against all other collidable objects not on conveyors
		for (conveyorMovable => targetPoint in conveyorMovableToDesiredPoint) {
			if (player == conveyorMovable) {
				if (nonConveyorPlayerCollidables.filter(o -> o.overlapsPoint(targetPoint)).length > 0) {
					conveyorMovableToDesiredPoint[conveyorMovable] = conveyorMovable.getMidpoint();
				}
			} else {
				if (nonConveyorObjects.filter(o -> o.overlapsPoint(targetPoint)).length > 0) {
					conveyorMovableToDesiredPoint[conveyorMovable] = conveyorMovable.getMidpoint();
				}
			}
		}

		// While any desired points of objects on the conveyors are duplicates, resolve the map
		var movementsDuplicateValues = getMapDuplicateValues(conveyorMovableToDesiredPoint);
		while (movementsDuplicateValues.length > 0) {
			for (duplicatePoint in movementsDuplicateValues) {
				resolveDuplicates(conveyorMovableToDesiredPoint, duplicatePoint);
			}

			movementsDuplicateValues = getMapDuplicateValues(conveyorMovableToDesiredPoint);
		}

		// Move objects on conveyors based on their final desired points
		var conveyorWorkNeeded = false;
		for (object => point in conveyorMovableToDesiredPoint) {
			if (!object.overlapsPoint(point)) {
				FlxTween.linearMotion(object, object.x, object.y, point.x - (Constants.TILE_SIZE / 2), point.y - (Constants.TILE_SIZE / 2),
					runningTimeDuration);
				conveyorWorkNeeded = true;
			}
		}

		// End running early if nothing was found on conveyors
		if (!conveyorWorkNeeded)
			forciblyStopRunning();
	}

	private function isNotWithinMapKey(inValue:FlxObject, map:Map<DepthSprite, FlxPoint>):Bool {
		for (value in map.keys()) {
			if (inValue == value)
				return false;
		}
		return true;
	}

	private function getMapDuplicateValues(map:Map<DepthSprite, FlxPoint>):Array<FlxPoint> {
		var valuesSeen:Array<FlxPoint> = new Array<FlxPoint>();
		var duplicateValues:Array<FlxPoint> = new Array<FlxPoint>();

		for (object => value in map) {
			if (valuesSeen.filter(p -> p.equals(value)).length == 1) {
				duplicateValues.push(value);
			} else {
				valuesSeen.push(value);
			}
		}

		return duplicateValues;
	}

	private function resolveDuplicates(map:Map<DepthSprite, FlxPoint>, duplicatePoint:FlxPoint) {
		for (object => point in map) {
			if (point == duplicatePoint) {
				map[object] = object.getMidpoint();
			}
		}
	}
}
