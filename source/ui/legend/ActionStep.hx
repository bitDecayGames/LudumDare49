package ui.legend;

@:enum abstract ActionStep(Int) to Int {
	var NONE = -1;
	var MOVEMENT = 0;
	var COOLING = 10;
	var CONVEYOR = 20;
	var DECAY = 30;
	var CHARGE = 40;
}
