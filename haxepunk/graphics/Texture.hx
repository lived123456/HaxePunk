package haxepunk.graphics;

import haxepunk.internal.Renderer;
import haxepunk.utils.Assets;

#if flash
import flash.display.BitmapData;
#else
import haxe.io.Bytes;
import haxe.io.BytesInput;
import lime.utils.UInt8Array;
import lime.utils.ByteArray;
#end

#if cpp
import cpp.vm.Thread;
#elseif neko
import neko.vm.Thread;
#end

typedef OnloadCallback = Void->Void;

class Texture
{

	/**
	 * The width of the texture
	 */
	public var width(default, null):Int = 0;

	/**
	 * The height of the texture
	 */
	public var height(default, null):Int = 0;

	public var onload(never, set):OnloadCallback;
	private function set_onload(value:OnloadCallback):OnloadCallback
	{
		_loaded ? value() : _onload.push(value);
		return value;
	}

	public static function create(path:String):Texture
	{
		var texture:Texture = null;
		if (_textures.exists(path))
		{
			texture = _textures.get(path);
		}
		else
		{
			texture = new Texture(path);
			_textures.set(path, texture);
		}
		return texture;
	}

	/**
	 * Creates a new Texture
	 * @param path The path to the texture asset
	 */
	private function new(path:String)
	{
		_onload = new Array<OnloadCallback>();
		loadImage(path);
	}

	/**
	 * Binds the texture for drawing
	 */
	public inline function bind():Void
	{
		Renderer.bindTexture(_texture);
	}

#if flash
	private function createTexture(width:Int, height:Int, data:BitmapData)
#else
	private function createTexture(width:Int, height:Int, data:UInt8Array)
#end
	{
		this.width = width;
		this.height = height;
		
		_texture = Renderer.createTexture(width, height, data);		

		for (onload in _onload)
		{
			onload();
		}
		
		_loaded = true;
	}

	private inline function toPowerOfTwo(value:Int):Int
	{
		return Std.int(Math.pow(2, Math.ceil(Math.log(value) / Math.log(2))));
	}

	private inline function loadImage(path:String)
	{
#if flash
		var imageData = Assets.getBitmapData(path);
		createTexture(imageData.width, imageData.height, imageData);
#else
	#if lime_html5
		var image: js.html.ImageElement = js.Browser.document.createImageElement();
		image.onload = function(a) {
			var width = toPowerOfTwo(image.width);
			var height = toPowerOfTwo(image.height);
			var tmpCanvas = js.Browser.document.createCanvasElement();
			tmpCanvas.width = width;
			tmpCanvas.height = height;

			var tmpContext = tmpCanvas.getContext2d();
			tmpContext.clearRect(0, 0, tmpCanvas.width, tmpCanvas.height);
			tmpContext.drawImage(image, 0, 0, image.width, image.height);

			var imageBytes = tmpContext.getImageData(0, 0, tmpCanvas.width, tmpCanvas.height);

			createTexture(width, height, new UInt8Array(imageBytes.data));

			tmpCanvas = null;
			tmpContext = null;
			imageBytes = null;
		};
		image.src = path;
	#elseif lime_native
		var t = Thread.create(function() {
			var current = Thread.readMessage(true);

			var bytes = Assets.getBytes(path);
			if (bytes == null) return;
			var byteInput = new BytesInput(bytes, 0, bytes.length);
			var png = new format.png.Reader(byteInput).read();
			var data = format.png.Tools.extract32(png);
			var header = format.png.Tools.getHeader(png);

			var byteData = #if neko ByteArray.fromBytes(data) #else data.getData() #end;
			var dataArray = new UInt8Array(byteData);
			// bgra to rgba (flip blue and red channels)
			var size = header.width * header.height;
			for (i in 0...size)
			{
				var b = dataArray[i*4];
				dataArray[i*4] = dataArray[i*4+2]; // r
				dataArray[i*4+2] = b; // b
			}
			current.sendMessage({
				type: "loadTexture",
				texture: this,
				width: header.width,
				height: header.height,
				data: dataArray
			});
		});
		t.sendMessage(Thread.current());
	#end
#end
	}

	private var _texture:GTexture;
	private var _onload:Array<OnloadCallback>;
	private var _loaded:Bool = false;
	private static var _textures = new Map<String, Texture>();

}
