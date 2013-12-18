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
import flash.display.BitmapData;
import flash.geom.Matrix;



/**
 * ...
 * @author Lorenzo Nuvoletta
 */
class WorldPlatform extends FlxSprite
{
    private const SLICE_HEIGHT           :int = 600;
    private const SLICE_WIDTH            :int = 30;
    private const INTERVAL               :Float = 1 / 60;

    private var _space                   :Space;
    private var _characterCbType         :CbType;
    private var _character               :FlxObject;
    private var _hills                   :Sprite;

    private var _groundTexture           :Texture;
    private var _slicesCreated           :Int;
    private var _currentAmplitude        :Float;
    private var _slicesInCurrentHill     :Int;
    private var _indexSliceInCurrentHill :Int;
    private var _currentYPoint           :Float = 600;
    private var _slices                  :Vector<FlxObject>;
    private var _sliceVectorConstructor  :Vector<Vec2>;

    public function WorldPlatform():void
    {
        //Initialize Nape Space
        _space = new Space(new Vec2(0, 2000));

        _hills = new Sprite();
        addChild(_hills);

        _slices = new Vector.<Body>();

        //Generate a rectangle made of Vec2
        _sliceVectorConstructor = new Vector.<Vec2>();
        _sliceVectorConstructor.push(new Vec2(0, SLICE_HEIGHT));
        _sliceVectorConstructor.push(new Vec2(0, 0));
        _sliceVectorConstructor.push(new Vec2(SLICE_WIDTH, 0));
        _sliceVectorConstructor.push(new Vec2(SLICE_WIDTH, SLICE_HEIGHT));

        //Create the texture of the ground
        _groundTexture = Texture.fromBitmapData(new BitmapData(SLICE_WIDTH, SLICE_HEIGHT, false, 0xffaa33));

        //fill the stage with slices of hills
        for (var i:int = 0; i < Main.stage.stageWidth / SLICE_WIDTH*1.2; i++) {
            createSlice();
        }

        _character = new Player();
        _character.space = _space;
        addChild(_character.graphic);

        startSimulation();
    }

    private function createSlice():void
    {
        //Every time a new hill has to be created this algorithm predicts where the slices will be positioned
        if (_indexSliceInCurrentHill >= _slicesInCurrentHill) {
            _slicesInCurrentHill = Math.random() * 40 + 10;
            _currentAmplitude = Math.random() * 60 - 20;
            _indexSliceInCurrentHill = 0;
        }

        //Calculate the position of the next slice
        var nextYPoint:Number = _currentYPoint + (Math.sin(((Math.PI / _slicesInCurrentHill) * _indexSliceInCurrentHill)) * _currentAmplitude);

        _sliceVectorConstructor[2].y = nextYPoint - _currentYPoint;

        var slicePolygon:Polygon = new Polygon(_sliceVectorConstructor);
        var sliceBody:Body = new Body(BodyType.STATIC);
        sliceBody.shapes.add(slicePolygon);
        sliceBody.position.x = _slicesCreated * SLICE_WIDTH;
        sliceBody.position.y = _currentYPoint;
        sliceBody.space = _space;

        var image:Image = new Image(_groundTexture);
        sliceBody.graphic = image;
        _hills.addChild(image);

        //Skew and position the image with a matrix
        var matrix:Matrix = image.transformationMatrix;
        matrix.translate(sliceBody.position.x, sliceBody.position.y);
        matrix.a = 1.04;
        matrix.b = (nextYPoint-_currentYPoint) / SLICE_WIDTH;
        image.transformationMatrix.copyFrom(matrix);

        _slicesCreated++;
        _indexSliceInCurrentHill++;
        _currentYPoint = nextYPoint;

        _slices.push(sliceBody);
    }

    private function startSimulation():void
    {
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(e:Event):void
    {
        _space.step(INTERVAL);
        checkHills();
        panForeground();
    }

    private function checkHills():void
    {
        for (var i:int = 0; i < _slices.length; i++) {
            if (_character.position.x - _slices[i].position.x > 600) {
                _space.bodies.remove(_slices[i]);
                if (_slices[i].graphic.parent) {
                    _slices[i].graphic.parent.removeChild(_slices[i].graphic);
                }
                _slices.splice(i, 1);
                i--;
                createSlice();
            }
            else {
                break;
            }
        }
    }

    private function panForeground():void
    {
        this.x = FlxG. / 2 - _character.position.x;
        this.y = Main.stage.stageHeight / 2 - _character.position.y;
    }
}