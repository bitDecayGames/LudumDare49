package entities;

import flixel.math.FlxPoint;
import ui.aura.Aura;
import flixel.FlxG;
import ui.counter.Counter;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class RadioactiveBlock extends Block {
	public static inline var OGMO_NAME = "radioactive";

	var decayAmount:Int = 0;
	var maxLife:Int = 0;
	var currentLife:Int = 0;
	var blowedUp:Bool = false;
	var auraColor:FlxColor = FlxColor.LIME;

	public var counter:Counter;

	public var aura:Aura;

	public function new(_decayAmount:Int = 1, _maxLife:Int = 10) {
		super(true);

		load_slices(AssetPaths.nuke__png, 16, 16, 16);

		decayAmount = _decayAmount;
		maxLife = _maxLife;
		currentLife = maxLife;
		counter = new Counter(0, 0, currentLife).setFollow(this);
		aura = new Aura(0,0, FlxColor.LIME, FlxPoint.get(-16, -16)).setFollow(this);
	}

	override public function update(delta:Float) {
		super.update(delta);

	}

	public function meltedDown() {
		return blowedUp;
	}

	public function isCritical() {
		return currentLife <= maxLife / 3;
	}

	public function decay() {
		currentLife -= decayAmount;
		updateAura();
		if (currentLife <= 0) {
			currentLife = 0;
			blowedUp = true;
		}
		counter.setCount(currentLife);
	}

	public function cool(coolAmount:Int) {
		currentLife += coolAmount;
		updateAura();
		if (currentLife > maxLife) {
			currentLife = maxLife;
		}
		counter.setCount(currentLife);
	}

	private function updateAura(){
		if(currentLife >= .66 * maxLife && auraColor != FlxColor.LIME){
			auraColor = FlxColor.LIME;
			aura.updateAura(FlxColor.LIME);
		}else if(currentLife > .33 * maxLife && currentLife < .66 * maxLife && auraColor != FlxColor.YELLOW){
			auraColor = FlxColor.YELLOW;
			aura.updateAura(FlxColor.YELLOW);
		}else if(currentLife <= .33 * maxLife && auraColor != FlxColor.RED){
			auraColor = FlxColor.RED;
			aura.updateAura(FlxColor.RED );
		}
	}
}
