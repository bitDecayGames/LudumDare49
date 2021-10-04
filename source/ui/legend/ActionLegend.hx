package ui.legend;

import flixel.FlxSprite;
import ui.camera.SetupCameras;
import signals.UI;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

class ActionLegend extends FlxSpriteGroup {
	private static var trayPadding = 16.0;
	private static var trayWidth = 124;
	private static var itemHeight = 24;

	private var tray:LegendTray;
	private var highlight:LegendHighlight;
	private var orderPosition:Int = 0;
	private var actionList:Array<ActionStep> = new Array<ActionStep>();
	private var actionMap:Map<ActionStep, LegendItem> = new Map<ActionStep, LegendItem>();

	public function new() {
		super();
		if (SetupCameras.uiCamera == null) {
			SetupCameras.SetupUICamera();
		}
		camera = SetupCameras.uiCamera;
		cameras = [camera];

		UI.highlightActionStep.add(setActionStep);
		UI.setActionSteps.add(setActionSteps);
		var halfPadding = trayPadding * .5;
		x = FlxG.width - (trayWidth + halfPadding);
		y = halfPadding;

		addTray();
		addHighlight();
	}

	override function remove(Sprite:FlxSprite, Splice:Bool = false):FlxSprite {
		UI.highlightActionStep.remove(setActionStep);
		UI.setActionSteps.remove(setActionSteps);
		return super.remove(Sprite, Splice);
	}

	private function setActionSteps(actionSteps:Array<ActionStep>) {
		var toRemove:Array<ActionStep> = [];
		for (step in actionList) {
			if (actionSteps.indexOf(step) < 0) {
				toRemove.push(step);
			}
		}
		for (actionStep in actionSteps) {
			if (actionList.indexOf(actionStep) < 0) {
				addActionStep(actionStep);
			}
		}
		for (step in toRemove) {
			removeActionStep(step);
		}
		visible = actionSteps.length != 0;
	}

	private function addActionStep(actionStep:ActionStep) {
		if (actionList.indexOf(actionStep) >= 0) {
			trace("Tried to add an action step to the legend that was already there");
			return;
		}
		var initialHighlightedAction:ActionStep = NONE;
		if (actionList.length > 0) {
			initialHighlightedAction = actionList[highlight.getOrderPosition()];
		}
		actionList.push(actionStep);
		actionList.sort((a, b) -> a - b);
		var item = LegendItemFactory.FromActionStep(actionStep);
		actionMap.set(actionStep, item);
		add(item);
		reorderItems();
		if (initialHighlightedAction != NONE) {
			setActionStep(initialHighlightedAction);
		}
	}

	private function removeActionStep(actionStep:ActionStep) {
		if (actionList.indexOf(actionStep) < 0) {
			trace("Tried to remove an action step to the legend that was not there");
			return;
		}
		var initialHighlightedAction:ActionStep = NONE;
		if (actionList.length > 0) {
			initialHighlightedAction = actionList[highlight.getOrderPosition()];
			if (actionStep == initialHighlightedAction) {
				// since we are removing the highlighted step, just set highlight to NONE
				initialHighlightedAction = NONE;
			}
		}
		actionList.remove(actionStep);
		actionList.sort((a, b) -> a - b);
		var item = actionMap.get(actionStep);
		remove(item);
		reorderItems();
		setActionStep(initialHighlightedAction);
	}

	private function reorderItems() {
		for (i in 0...actionList.length) {
			var item = actionMap.get(actionList[i]);
			item.x = x;
			item.y = i * itemHeight + y + (itemHeight * .4);
			item.setOrderNumber(i);
		}
		tray.setCount(actionList.length);
	}

	private function setActionStep(actionStep:ActionStep) {
		if (actionList == null) {
			trace("Action list was null, huh?");
			return;
		}
		highlight.visible = actionStep != NONE;
		var orderPosition = actionList.indexOf(actionStep);
		if (orderPosition < 0) {
			trace("Tried to set action legend to an unset action step: " + actionStep);
			return;
		}
		highlight.setOrderPosition(orderPosition);
	}

	private function addHighlight() {
		if (highlight == null) {
			highlight = new LegendHighlight(y, trayWidth, itemHeight);
		} else {
			remove(highlight);
		}
		add(highlight);
	}

	private function addTray() {
		if (tray == null) {
			tray = new LegendTray(trayWidth, itemHeight, 3, trayPadding);
		} else {
			remove(tray);
		}
		add(tray);
	}
}
