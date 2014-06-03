package haxepunk;

#if flash
import flash.Lib;
import flash.events.Event;
import flash.display3D.Context3D;
#else
import lime.Lime;
#end

#if cpp
import cpp.vm.Thread;
#elseif neko
import neko.vm.Thread;
#end

import haxepunk.scene.Scene;

class Engine
{
	
	public var scene(get, never):Scene;
	private inline function get_scene():Scene { return _scenes.first(); }

	public function new(?scene:Scene)
	{
		_scenes = new List<Scene>();
		pushScene(scene == null ? new Scene() : scene);
		
	#if flash
		Lib.current.stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, ready);
		Lib.current.stage.stage3Ds[0].requestContext3D();
	#end
	}

#if flash
	private function ready(_):Void
	{
		flash = Lib.current.stage.stage3Ds[0].context3D;
		HXP.windowWidth = Lib.current.stage.stageWidth;
		HXP.windowHeight = Lib.current.stage.stageHeight;
		flash.configureBackBuffer(width, height, 0, true);
		
		Lib.current.addEventListener(Event.ENTER_FRAME, render);
		
		init();
	}
#else
	public function ready(lime:Lime):Void
	{
		this.lime = lime;
		HXP.windowWidth = this.lime.config.width;
		HXP.windowHeight = this.lime.config.height;
		
		init();
	}
#end

	/**
	 * This function is called when the engine is ready. All initialization code should go here.
	 */
	public function init()
	{
		throw "Override the init function to begin";
	}

	private function render():Void
	{
		scene.draw();
	}

	private function update():Void
	{
#if (neko || cpp)
		var msg = Thread.readMessage(false);
		if (msg != null)
		{
			switch (msg.type)
			{
				case "loadTexture":
					msg.texture.createTexture(msg.width, msg.height, msg.data);
			}
		}
#end

		scene.update();
	}

	/**
	 * Replaces the current scene
	 * @param scene The replacement scene
	 */
	public function replaceScene(scene:Scene)
	{
		_scenes.pop();
		_scenes.push(scene);
	}

	/**
	 * Pops a scene from the stack
	 */
	public function popScene()
	{
		// should always have at least one scene
		if (_scenes.length > 1)
		{
			_scenes.pop();
		}
	}

	/**
	 * Pushes a scene (keeping the old one to use later)
	 * @param scene The scene to push
	 */
	public function pushScene(scene:Scene)
	{
		_scenes.push(scene);
	}

	private var _scenes:List<Scene>;
	
#if flash
	private var flash:Context3D;
#else
	private var lime:Lime;	
#end

}
