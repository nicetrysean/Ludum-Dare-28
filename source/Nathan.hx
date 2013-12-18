package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * ...
 * @author tf
 */

class Nathan extends FlxSprite
{

    public var _jumping:Bool;

    public function new(_x: Int, _y:Int)
    {
        super();
        loadGraphic("assets/images/nathan.png", true, true, 30, 31, true);

        //customize the player
        x = _x;
        y = _y;
        scale = new FlxPoint(5, 5);
        width = 90;
        height = 90;
        acceleration.y = 200;
        drag.x = 100;

        //add in the animation
        animation.add('default', [2], 17);
        animation.add('run', [0, 1], 3, true);

        //play("default");
        _jumping = true;
    }

    override public function update() {
        x++;
        animation.play('run');
        super.update();
    }

}