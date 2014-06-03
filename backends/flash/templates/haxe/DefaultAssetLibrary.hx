package;


import haxe.Timer;
import haxe.Unserializer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.Font;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import flash.Assets;

import flash.display.Loader;
import flash.events.Event;
import flash.net.URLLoader;


@:access(flash.media.Sound)
class DefaultAssetLibrary extends AssetLibrary {
	
	
	public var className (default, null) = new Map <String, Dynamic> ();
	public var path (default, null) = new Map <String, String> ();
	public var type (default, null) = new Map <String, AssetType> ();
	
	private var lastModified:Float;
	private var timer:Timer;
	
	
	public function new () {
		
		super ();
		
		::if (assets != null)::::foreach assets::::if (embed)::className.set ("::id::", __ASSET__::flatName::);::else::path.set ("::id::", "::resourceName::");::end::
		type.set ("::id::", AssetType.$$upper(::type::));
		::end::::end::
		
	}
	
	
	public override function exists (id:String, type:AssetType):Bool {
		
		var assetType = this.type.get (id);
		
		if (assetType != null) {
			
			if (assetType == type || ((type == SOUND || type == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			if ((assetType == BINARY || assetType == TEXT) && type == BINARY) {
				
				return true;
				
			} else if (path.exists (id)) {
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	public override function getBitmapData (id:String):BitmapData {
		
		return cast (Type.createInstance (className.get (id), []), BitmapData);
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);
		
	}
	
	
	public override function getFont (id:String):Font {
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
	}
	
	
	public override function getMusic (id:String):Sound {
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
	}
	
	
	public override function getPath (id:String):String {
		
		return path.get (id);
		
	}
	
	
	public override function getSound (id:String):Sound {
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
	}
	
	
	public override function getText (id:String):String {
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
	}
	
	
	public override function isLocal (id:String, type:AssetType):Bool {
		
		if (type != AssetType.MUSIC && type != AssetType.SOUND) {
			
			return className.exists (id);
			
		}
		
		return true;
		
	}
	
	
	public override function list (type:AssetType):Array<String> {
		
		var items = [];
		
		for (id in this.type.keys ()) {
			
			if (type == null || exists (id, type)) {
				
				items.push (id);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public override function loadBitmapData (id:String, handler:BitmapData -> Void):Void {
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBitmapData (id));
			
		}
		
	}
	
	
	public override function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = new ByteArray ();
				bytes.writeUTFBytes (event.currentTarget.data);
				bytes.position = 0;
				
				handler (bytes);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBytes (id));
			
		}
		
	}
	
	
	public override function loadFont (id:String, handler:Font -> Void):Void {
		
		handler (getFont (id));
		
	}
	
	
	public override function loadMusic (id:String, handler:Sound -> Void):Void {
		
		handler (getMusic (id));
		
	}
	
	
	public override function loadSound (id:String, handler:Sound -> Void):Void {
		
		handler (getSound (id));
		
	}
	
	
	public override function loadText (id:String, handler:String -> Void):Void {
		
		var callback = function (bytes:ByteArray):Void {
			
			if (bytes == null) {
				
				handler (null);
				
			} else {
				
				handler (bytes.readUTFBytes (bytes.length));
				
			}
			
		}
		
		loadBytes (id, callback);
		
	}
	
	
}

::foreach assets::
	::if (embed)::
		::if (type == "image")::
			@:keep @:bitmap("::sourcePath::") class __ASSET__::flatName:: extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
		::else::
			@:keep class __ASSET__::flatName:: extends ::flashClass:: { }
		::end::
	::end::
::end::
