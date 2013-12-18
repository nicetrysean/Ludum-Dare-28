package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import flixel.util.FlxColor;
import flixel.tile.FlxTilemap;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var bg : FlxSprite;
	private var player:FlxSprite;
	private var nathan:FlxSprite;
	private var map: FlxSprite;
	private var _emitter :FlxEmitter;
	private var _whitePixel: FlxParticle;
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		var bg : FlxSprite = new FlxSprite(0, 0, "assets/images/bg1.png");
		bg.scale = new FlxPoint(2, 2);
		bg.setPosition(FlxG.width, FlxG.height);
		bg.scrollFactor = new FlxPoint(.6, .6);
		add(bg);

		var bg : FlxSprite = new FlxSprite(0, 0, "assets/images/bg2.png");
		bg.scale = new FlxPoint(2, 2);
		bg.setPosition(FlxG.width, FlxG.height);
		bg.scrollFactor = new FlxPoint(.8, .8);
		add(bg);

		map = new FlxSprite(FlxG.width - bg.width, FlxG.height - bg.height);
		map.height = 8;
		map.width = 5000;
		map.immovable = true;
		map.centerOffsets(true);
		add(map);

        FlxG.worldDivisions = 8;

		nathan = new Nathan(180, 140);
        add(nathan);

        _emitter = new FlxEmitter(0, 0, 20);

		player = new Player(40, 100);
		//add(player);

		FlxG.camera.follow(nathan);
		FlxG.worldBounds.set(0, 0, 2000, 5000);
		super.create();
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		FlxG.collide(map, player);
		FlxG.collide(map, nathan);

        _emitter.x = (Std.random(200) / 138) * nathan.x;
		_emitter.y = (Std.random(200) / 138) * nathan.y;

        // Now by default the emitter is going to have some properties set on it and can be used immediately
        // but we're going to change a few things.

        // First this emitter is on the side of the screen, and we want to show off the movement of the particles
        // so lets make them launch to the right.
        _emitter.setXSpeed(100, 200);

        // and lets funnel it a tad
        _emitter.setYSpeed( -50, 50);

        // Let's also make our pixels rebound off surfaces
        _emitter.bounce = 0.8;

        // Now let's add the emitter to the state.
        add(_emitter);

        add(_emitter);
        for (i in 0...(Std.int(_emitter.maxSize / 2)))
        {
            _whitePixel = new FlxParticle();
            _whitePixel.makeGraphic(2, 2, FlxColor.WHITE);
            // Make sure the particle doesn't show up at (0, 0)
            _whitePixel.visible = false;
            _emitter.add(_whitePixel);
            _whitePixel = new FlxParticle();
            _whitePixel.makeGraphic(1, 1, FlxColor.WHITE);
            _whitePixel.visible = false;
            _emitter.add(_whitePixel);
        }
        _emitter.start(false, 3, .01);
		super.update();
	}
}