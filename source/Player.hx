package ;
import flash.display.Graphics;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxPoint;
import flash.utils.Timer;
import flash.display.Sprite;
import flash.events.Event;

/**
 * ...
 * @author tf
 */

class Player extends FlxSprite
{

    public var _jumping:Bool;
    private var pivot:FlxSprite;
    public var GRAVITY : Float = 400;
    private var LENGTH: Float = 100;
    public var x0 : Float;      // Center position
    public var y0 : Float;
    public var x1 : Float;      // Weight position (center)
    public var y1 : Float;
    public var rho : Float;     // Distance from center
    public var theta : Float;   // Angle around center
    public var omega : Float;   // Angular velocity

    private static inline var GRAV: Float = 9.8;

    private var _armLen: Float;
    private var _rad: Float;

    private var _lastT: Int;
    private var _dt: Float;
    private var _w: Float = 0;
    private var _theta: Float = 0;

    public var swingInfo: Float;
    private var _diff: FlxPoint;
    private var _last: FlxPoint;

    public function new(_x: Int, _y:Int)
    {
        super();
        loadGraphic("assets/images/player.png", true, true, 30, 31, true);

        pivot = new FlxSprite( (FlxG.width >> 1) - 5, (FlxG.height >> 1) - 5);
        pivot.makeGraphic(10, 10, 0xFFFF0000);

        acceleration.y = GRAVITY;

        //customize the player
        x = _x;
        y = _y;
        acceleration.y = 200;
        drag.x = 100;

        //add in the animation
        animation.add('default', [0], 3);
        animation.add('run', [0, 1, 2], 17, true);
        animation.add('jump', [2]);
        //play("default");
        _jumping = true;
    }

    override public function update() {

        if (FlxG.keyboard.pressed("LEFT", "A"))
        {
            velocity.x = -70;
            facing = FlxObject.LEFT;
        }

        if (FlxG.keyboard.pressed("RIGHT", "D"))
        {
            velocity.x = 70;
            facing = FlxObject.RIGHT;
        }

        if (FlxG.keyboard.justPressed("SPACE", "UP", "W") && isTouching(FlxObject.FLOOR))
        {
            _jumping = true;
        }

        if(velocity.x != 0)
            animation.play('run');
        else
            animation.play('default');
        if (_jumping && velocity.y == 0) {
            _jumping = false;
        }
    }

}