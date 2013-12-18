package;

import flixel.FlxSprite;

class Parallax extends FlxSprite
{

	private var _speed  : Float;
	private var _images : Array<FlxSprite>;
	private var _width  : Float;
	private var _height : Float;

	override public function new( images: Array<FlxSprite>, speed: Float):Void
	{

		_speed = speed;
		_images = images;
	}

	override public function init() : Void
	{
		for (image in _images)
		{
			add(image);
		}
	}

	override public function update():Void
	{

		for (image in _images)
		{
			image.x -= _speed * ( p_deltaTime * .001 ); // keeps _speed constant
			if ( image.x <= -_width) {
				var l_offset =  image.x + _width;
				image.x = _width + l_offset;
			}
		}
		super.update();
	}
}