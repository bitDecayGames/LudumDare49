package systems;

import flixel.FlxSprite;
import entities.RadioactiveBlock;
import flixel.group.FlxGroup;

class DecaySystem extends StateSystem{
    
    var collidables:FlxTypedGroup<FlxSprite>;
    

    public function new(_collidables:FlxTypedGroup<FlxSprite>)
    {
        super();

        collidables = _collidables;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
	}

    public function handleDecay(){
        setRunning();

        var decayWorkNeeded = false;
        for (reactor in collidables.members.filter(col -> Std.isOfType(col, RadioactiveBlock)).map(col -> cast(col, RadioactiveBlock)))
        {
            decayWorkNeeded = true;
            reactor.decay();
        }

        if (!decayWorkNeeded) forciblyStopRunning();
    }

    public function getAllMeltdowns(): Array<RadioactiveBlock>{

        return collidables.members.filter(col -> Std.isOfType(col, RadioactiveBlock)).map(col -> cast(col, RadioactiveBlock)).filter(d -> d.meltedDown());
    }
}