package signals;

import ui.legend.ActionStep;
import flixel.util.FlxSignal;

class UI {
	public static var highlightActionStep:FlxTypedSignal<ActionStep->Void> = new FlxTypedSignal<ActionStep->Void>();
	public static var setActionSteps:FlxTypedSignal<Array<ActionStep>->Void> = new FlxTypedSignal<Array<ActionStep>->Void>();
}
