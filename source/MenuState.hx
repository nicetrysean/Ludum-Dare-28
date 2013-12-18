package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{

	var gibs:FlxEmitter;
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !mobile
		  FlxG.mouse.show();
		#end

       	gibs = new FlxEmitter(FlxG.width/2-50, FlxG.height/3);
        gibs.setSize(100, 30);
        gibs.setYSpeed(-200, -20);
        gibs.setRotation(-720, 720);
        gibs.gravity = 100;

        gibs.makeParticles("assets/images/spawner_gibs.png", 30, 32, true, 0);
        gibs.setScale( 1, 3, 3, 5);
        add(gibs);

	    var title: FlxText = new FlxText(FlxG.width / 10, FlxG.height / 4, 704, "Nathan Time");
	    title.size = 44;
	    title.color = 0x448EDF;
	    add(title);

	    var titlef: FlxText = new FlxText(title.width/2 - 15, title.y + 50, 504, "By Young Sean");
	    titlef.size = 15;
	    titlef.color = 0xff877c;
	    add(titlef);

	    var letsPlay: FlxButton = new FlxButton(FlxG.width / 2 - 40, title.y + title.y, "Spend Time with Nathan!", onPlay);
	    letsPlay.scale.x = 2;
	    letsPlay.scale.y = 4;
	    letsPlay.color = 0x448EDF;
	    letsPlay.label.color = 0xF7F7F7;
	    letsPlay.label.y = 0;
	    add(letsPlay);

	    gibs.start(true,5);

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

	public function onPlay():Void
	{
		FlxG.camera.fade(0xff131c1b, 1, nowSwitch);
	}

	public function nowSwitch()
	{
		FlxG.switchState(new PlayState());
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{

		super.update();
	}
}
