package systems;

import haxe.Exception;
import helpers.Constants;
import spacial.Cardinal;
import flixel.math.FlxPoint;
import entities.PowerCore;
import flixel.FlxSprite;
import entities.RadioactiveCooler;
import entities.RadioactiveBlock;
import flixel.FlxBasic;
import flixel.group.FlxGroup;

class DecaySystem extends FlxBasic{
    
    var decayingObjects:Array<RadioactiveBlock>;

    public function new(_collidables:FlxTypedGroup<FlxSprite>)
    {
        super();

        decayingObjects = _collidables.members.filter(col -> Std.isOfType(col, RadioactiveBlock)).map(col -> cast(col, RadioactiveBlock));
    }

    override public function update(elapsed:Float) {
        handleDecay();
	}

    public function getAllMeltdowns(): Array<RadioactiveBlock>{
        return decayingObjects.filter(d -> d.meltedDown());
    }

    private function handleDecay(){
        for(reactor in decayingObjects){
            reactor.decay();
        }
    }
    
}