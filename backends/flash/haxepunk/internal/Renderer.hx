package haxepunk.internal;

import flash.Lib;
import flash.display.BitmapData;
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.events.Event;

@:allow(haxepunk.Engine)
class Renderer
{
	
	public static var ONE_MINUS_SRC_ALPHA = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
	public static var SRC_ALPHA = Context3DBlendFactor.SOURCE_ALPHA;
	
	public static inline function bindTexture(texture:GTexture):Void
	{
		// TODO
	}
	
	public static inline function clear(r:Float, g:Float, b:Float, a:Float):Void
	{
		ctx.clear(r, g, b, a);
	}
	
	public static inline function createTexture(width:Int, height:Int, data:BitmapData):GTexture
	{
		var texture = ctx.createTexture(width, height, flash.display3D.Context3DTextureFormat.BGRA, false);
		texture.uploadFromBitmapData(data);
		
		return texture;
	}
	
	public static inline function enableBlend(sfactor:Context3DBlendFactor, dfactor:Context3DBlendFactor):Void
	{
		ctx.setBlendFactors(sfactor, dfactor);
	}
	
	public static inline function enableDepthTest():Void
	{
		depthTest = true;
		reconfigureBackBuffer();
	}
	
	public static inline function get3DContext(ready:Dynamic->Void):Void
	{
		stage3D = Lib.current.stage.stage3Ds[0];
		stage3D.addEventListener(Event.CONTEXT3D_CREATE, ready);
		stage3D.requestContext3D();
	}
	
	public static inline function present():Void
	{
		ctx.present();
	}
	
	public static inline function reconfigureBackBuffer():Void
	{
		ctx.configureBackBuffer(width, height, antialiasing, depthTest);
	}
	
	public static inline function viewport(x:Int, y:Int, width:Int, height:Int):Void
	{
		//stage3D.x = x;
		//stage3D.y = y;
		Renderer.width = width;
		Renderer.height = height;
		reconfigureBackBuffer();
	}
	
	private static var ctx:Context3D;
	private static var stage3D:Stage3D;
	private static var width:Int = 0;
	private static var height:Int = 0;
	private static var antialiasing:Int = 0;
	private static var depthTest:Bool = false;
	
}

typedef Buffer = Dynamic; // temp

typedef GTexture = flash.display3D.textures.Texture;
