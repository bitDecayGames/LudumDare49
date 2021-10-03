package systems;

import flixel.FlxBasic;

enum SystemState {
	Idle;
	Running;
	Done;
}

class StateSystem extends FlxBasic {
	var state:SystemState = Idle;

	var runningTime:Float = 0;
	var runningTimeDuration:Float = 1;
	var defaultRunningTimeDuration:Float = 1;

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (isRunning()) {
			runningTime -= elapsed;
		}

		if (runningTime < 0) {
			runningTime = 0;
			setDone();
		}
	}

	public function setRunningTimeDuration(time:Float) {
		runningTimeDuration = time;
	}

	public function setRunningTimeDurationPercent(percent:Float) {
		runningTimeDuration *= percent;
	}

	public function resetRunningTimeDuration() {
		runningTimeDuration = defaultRunningTimeDuration;
	}

	public function forciblyStopRunning() {
		runningTime = 0;
	}

	public function setIdle() {
		state = Idle;
	}

	public function setRunning() {
		runningTime = runningTimeDuration;
		state = Running;
	}

	public function setDone() {
		state = Done;
	}

	public function isIdle() {
		return state == Idle;
	}

	public function isRunning() {
		return state == Running;
	}

	public function isDone() {
		return state == Done;
	}
}
