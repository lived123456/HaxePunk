package haxepunk.scene;

import haxepunk.graphics.Graphic;
import haxepunk.utils.Matrix3D;
import haxepunk.utils.Vector3D;

class Entity
{

	public var position:Vector3D;

	public var x(get, set):Float;
	private inline function get_x():Float { return position.x; }
	private inline function set_x(value:Float) { return position.x = value; }

	public var y(get, set):Float;
	private inline function get_y():Float { return position.y; }
	private inline function set_y(value:Float) { return position.y = value; }

	public var z(get, set):Float;
	private inline function get_z():Float { return position.z; }
	private inline function set_z(value:Float) { return position.z = value; }

	public var layer(get, set):Float;
	private inline function get_layer():Float { return position.z; }
	private inline function set_layer(value:Float) { return position.z = value; }

	public function new(x:Float = 0, y:Float = 0, z:Float = 0)
	{
		position = new Vector3D(x, y, z);
		modelViewMatrix = new Matrix3D();
	}

	public function addGraphic(graphic:Graphic):Void
	{
		if (_graphic == null)
		{
			_graphic = graphic;
		}
		else if (Std.is(_graphic, GraphicList))
		{
			cast(_graphic, GraphicList).add(graphic);
		}
		else
		{
			_graphic = new GraphicList([_graphic, graphic]);
		}
	}

	public function draw(projectionMatrix:Matrix3D)
	{
		modelViewMatrix.identity();
		modelViewMatrix.appendTranslation(position.x, position.y, position.z);

		if (_graphic != null) _graphic.draw(projectionMatrix, modelViewMatrix);
	}

	public function update()
	{

	}

	private var _graphic:Graphic;
	private var modelViewMatrix:Matrix3D;

}
