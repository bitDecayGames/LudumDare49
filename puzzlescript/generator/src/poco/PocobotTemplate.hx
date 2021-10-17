package poco;

class PocobotTemplate {
	var MaxReactor:String;
	var ReactorNameList:String;
	var BatteryNameList:String;
	var ReactorObjects:Array<String>;
	var ReactorPushRules:Array<String>;
	var BatteryPushRules:Array<String>;
	var ReactorConveyorRules:Array<String>;
	var BatteryConveyorRules:Array<String>;
	var ReactorDecayRules:Array<String>;
	var ReactorChargeOriginRules:Array<String>;
	var BatteryChargeRules:Array<String>;
	var BatteryWinConditions:Array<String>;

	private var batteryMax:Int;
	private var reactorLoopStart:Int = 1;
	private var reactorLoopMax:Int;

	public function new(reactorMax:Int, batteryMax:Int) {
		reactorLoopMax = reactorMax + 1;
		this.batteryMax = batteryMax;

		MaxReactor = 'React${reactorMax}';
		ReactorNameList = getReactorNameList();
		BatteryNameList = getBatteryNameList();
		ReactorObjects = getReactorObjects();
		ReactorPushRules = getReactorPushRules();
		BatteryPushRules = getBatteryPushRules();
		ReactorConveyorRules = getReactorConveyorRules();
		BatteryConveyorRules = getBatteryConveyorRules();
		ReactorDecayRules = getReactorDecayRules();
		ReactorChargeOriginRules = getReactorChargeOriginRules();
		BatteryChargeRules = getBatteryChargeRules();
		BatteryWinConditions = getBatteryWinConditions();
	}

	public function getDynamic():Dynamic {
		return {
			"MaxReactor": MaxReactor,
			"ReactorNameList": ReactorNameList,
			"BatteryNameList": BatteryNameList,
			"ReactorObjects": ReactorObjects.join("\n"),
			"BatteryObjects": getBatteryObjects().join("\n"),
			"ReactorPushRules": ReactorPushRules.join("\n"),
			"BatteryPushRules": BatteryPushRules.join("\n"),
			"ReactorConveyorRules": ReactorConveyorRules.join("\n"),
			"BatteryConveyorRules": BatteryConveyorRules.join("\n"),
			"ReactorDecayRules": ReactorDecayRules.join("\n"),
			"ReactorCoolRules": getReactorCoolRules().join("\n"),
			"ReactorChargeOriginRules": ReactorChargeOriginRules.join("\n"),
			"BatteryChargeRules": BatteryChargeRules.join("\n"),
			"BatteryWinConditions": BatteryWinConditions.join("\n"),
		};
	}

	function getReactorNameList():String {
		return [for (i in reactorLoopStart...reactorLoopMax) {
			'React${i}';
		}].join(", ");
	}

	function getBatteryNameList():String {
		return [for (i in 0...batteryMax) {
			'Battery${i}';
		}].join(", ");
	}

	function getReactorObjects():Array<String> {
		var output = new Array<String>();

		for (i in reactorLoopStart...reactorLoopMax) {
			output.push('React${i}');
			output.push('DarkGreen Blue Green Yellow');
			for (row in fill(3, i)) {
				output.push(row);
			}
			output.push("");
		}

		return output;
	}

	function getBatteryObjects():Array<String> {
		var output = new Array<String>();

		for (i in 0...batteryMax) {
			output.push('Battery${i}');
			output.push('Purple Green');
			for (row in fill(3, i)) {
				output.push(row);
			}
			output.push("");
		}

		return output;
	}

	function getReactorDecayRules():Array<String> {
		var rules = new Array<String>();
		rules.push('late [ React1 No CoolAuraFinal ] -> [ Meltdown ]');
		for (i in reactorLoopStart+1...reactorLoopMax) {
			rules.push('late [ React${i} No CoolAuraFinal ] -> [ React${i-1} ]');
		}
		return rules;
	}

	function getReactorChargeOriginRules():Array<String> {
		var rules = new Array<String>();
		for (i in reactorLoopStart...reactorLoopMax) {
			rules.push('late [ React${i} ] -> [ React${i} ChargeAuraCenter ]');
		}
		return rules;
	}

	function getReactorCoolRules():Array<String> {
		var rules = new Array<String>();
		rules.push('late [ CoolAuraFinal Meltdown ] -> [ CoolAuraFinal React1 ]');
		for (i in reactorLoopStart...reactorLoopMax-1) {
			rules.push('late [ CoolAuraFinal React${i} ] -> [ CoolAuraFinal React${i+1} ]');
		}
		// These rules need to go in reverse order so they don't chain and cause reactors to fully cool
		// every cycle of the game
		rules.reverse();
		return rules;
	}

	function getBatteryChargeRules():Array<String> {
		var rules = new Array<String>();
		for (i in 1...batteryMax) {
			rules.push('late [ ChargeAuraFinal Battery${i-1} ] ->  [ ChargeAuraFinal Battery${i} ] ${i == batteryMax - 1 ? " message Battery Charged!" : ""}');
		}
		// These rules need to go in reverse order so they don't chain and cause batteries to fully
		// charge every cycle of the game
		rules.reverse();
		return rules;
	}

	function getBatteryWinConditions():Array<String> {
		var rules = new Array<String>();
		for (i in 0...batteryMax-1) {
			rules.push('No Battery${i}');
		}
		return rules;
	}

	function getReactorPushRules():Array<String> {
		var rules = new Array<String>();
		for (i in reactorLoopStart...reactorLoopMax) {
			rules.push('[ >  Player | React${i} ] -> [ >  Player | > React${i} ]');
		}
		return rules;
	}

	function getReactorConveyorRules():Array<String> {
		var rules = new Array<String>();
		for (i in reactorLoopStart...reactorLoopMax) {
			rules.push('UP    [ ConvU stationary React${i} | ] -> [  ConvU > React${i} | ]');
			rules.push('DOWN  [ ConvD stationary React${i} | ] -> [  ConvD > React${i} | ]');
			rules.push('LEFT  [ ConvL stationary React${i} | ] -> [  ConvL > React${i} | ]');
			rules.push('RIGHT [ ConvR stationary React${i} | ] -> [  ConvR > React${i} | ]');
			}
		return rules;
	}

	function getBatteryConveyorRules():Array<String> {
		var rules = new Array<String>();
		for (i in 0...batteryMax) {
			rules.push('UP    [ ConvU stationary Battery${i} | ] -> [  ConvU > Battery${i} | ]');
			rules.push('DOWN  [ ConvD stationary Battery${i} | ] -> [  ConvD > Battery${i} | ]');
			rules.push('LEFT  [ ConvL stationary Battery${i} | ] -> [  ConvL > Battery${i} | ]');
			rules.push('RIGHT [ ConvR stationary Battery${i} | ] -> [  ConvR > Battery${i} | ]');
			}
		return rules;
	}

	function getBatteryPushRules():Array<String> {
		var rules = new Array<String>();
		for (i in 0...batteryMax) {
			rules.push('[ >  Player | Battery${i} ]  -> [  >  Player | > Battery${i}  ]');
		}
		return rules;
	}

	function fill(width:Int=3, fill:Int=1):Array<String> {
		// Sys.println('');
		// Sys.println('fill for width ${width}, fill ${fill}');

		var cells = width * width;
		// Sys.println('cells ${cells}');

		var fills = Std.int(fill / cells);
		// Sys.println('fills ${fills}');

		var total = fill % cells;
		// Sys.println('total ${total}');

		// var cycle = Std.int(fill / (cells + 1));
		// Sys.println('cycle ${cycle}');

		var color = fills + 1;
		// Sys.println('color ${color}');

		var rows = [for (r in 0...width) {
			var onRow = total - (r * width);
			var rowMiddle = [for (c in 0...width) '${c < onRow ? color : color - 1}'];
			rowMiddle.insert(0, "0");
			rowMiddle.push("0");
			rowMiddle.join("");
		}];

		rows.reverse();
		rows.insert(0, '00000');
		rows.push('00000');
		return rows;
	}
}