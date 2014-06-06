#if (!macro || !haxe3)

import ::APP_MAIN_PACKAGE::::APP_MAIN_CLASS::;
import flash.display.DisplayObject;
import flash.Lib;


class ApplicationMain {
	
	
	public static function main () {
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields (::APP_MAIN::)) {
			
			if (methodName == "main") {
				
				hasMain = true;
				break;
				
			}
			
		}
		
		if (hasMain) {
			
			Reflect.callMethod (::APP_MAIN::, Reflect.field (::APP_MAIN::, "main"), []);
			
		} else {
			
			var instance = Type.createInstance (DocumentClass, []);
			
			if (Std.is (instance, DisplayObject)) {
				
				Lib.current.addChild (cast instance);
				
			}
			
		}
		
	}
	
	
}

@:build(DocumentClass.build())
@:keep class DocumentClass extends ::APP_MAIN:: { }


#else


import haxe.macro.Context;
import haxe.macro.Expr;


class DocumentClass {
	
	
	macro public static function build ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes.superClass != null) {
			
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				var method = macro {
					return flash.Lib.current.stage;
				}
				
				fields.push ({ name: "get_stage", access: [ APrivate ], meta: [ { name: ":getter", params: [ macro stage ], pos: Context.currentPos() } ], kind: FFun({ args: [], expr: method, params: [], ret: macro :flash.display.Stage }), pos: Context.currentPos() });
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
}


#end
