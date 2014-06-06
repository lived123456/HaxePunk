package haxepunk.utils;

import flash.Vector;

class Matrix3D extends flash.geom.Matrix3D
{
	public function new(?v:Array<Float>) 
	{
		super(Vector.ofArray(v));
	}
	
	public static function create2D(x:Float, y:Float, scale:Float = 1, rotation:Float = 0) 
	{
		var theta = rotation * Math.PI / 180.0;
		var c = Math.cos(theta);
		var s = Math.sin(theta);

		return new Matrix3D([
			c*scale,  -s*scale, 0,  0,
			s*scale,  c*scale,  0,  0,
			0,        0,        1,  0,
			x,        y,        0,  1
		]);
	}

	public static function createABCD(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float) 
	{
		return new Matrix3D([
			a, b, 0, 0,
			c, d, 0, 0,
			0, 0, 1, 0,
			tx,ty,0, 1
		]);
	}

	public static function createOrtho(x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float) 
	{
		var sx = 1.0 / (x1 - x0);
		var sy = 1.0 / (y1 - y0);
		var sz = 1.0 / (zFar - zNear);

		return new Matrix3D([
			2.0*sx,       0,          0,                 0,
			0,            2.0*sy,     0,                 0,
			0,            0,          -2.0*sz,           0,
			- (x0+x1)*sx, - (y0+y1)*sy, - (zNear+zFar)*sz,  1,
		]);
	}
}
