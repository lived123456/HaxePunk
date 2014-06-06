package haxepunk.internal;

import lime.Lime;
import lime.gl.GL;
import lime.utils.UInt8Array;

@:allow(haxepunk.Engine)
class Renderer
{
	
	public static inline var ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA;
	public static inline var SRC_ALPHA = GL.SRC_ALPHA;
	
	public static inline function bindTexture(texture:GTexture):Void
	{		
		GL.bindTexture(GL.TEXTURE_2D, texture);
	}
	
	public static inline function clear(r:Float, g:Float, b:Float, a:Float):Void
	{
		GL.clearColor(r, g, b, a);
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
	}
	
	public static inline function createTexture(width:Int, height:Int, data:UInt8Array):GTexture
	{
		var texture = GL.createTexture();
		
		GL.bindTexture(GL.TEXTURE_2D, texture);
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
		GL.bindTexture(GL.TEXTURE_2D, null);
		
		return texture;
	}
	
	public static inline function enableBlend(sfactor:Int, dfactor:Int):Void
	{
		GL.enable(GL.BLEND);
		GL.blendFunc(sfactor, dfactor);
	}
	
	public static inline function enableDepthTest():Void
	{
		GL.enable(GL.DEPTH_TEST);
	}
	
	public static inline function present():Void
	{
	}
	
	public static inline function viewport(x:Int, y:Int, width:Int, height:Int):Void
	{
		#if !neko
		GL.viewport(x, y, width, height);
		#end
	}
	
	private static var lime:Lime;

}

typedef Buffer = lime.gl.GLBuffer;

typedef GTexture = lime.gl.GLTexture;
