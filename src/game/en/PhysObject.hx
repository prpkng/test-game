package en;

import dn.Delayer;
import echo.shape.Rect;
import echo.data.Options.ShapeOptions;
import echo.data.Types.MassType;
import echo.math.Vector2;
import echo.shape.Circle;
import h2d.Graphics;

class PhysObject extends Entity {
	public var body:echo.Body;

	var debugPhysShape:Null<Graphics>;
	var invalidateDebugPhysShape:Bool;

	var target:Entity;

	public function new(x:Float, y:Float, isStatic = false, ?shapes:Array<ShapeOptions>) {
		super(cast x, cast y);
		body = PhysWorld.world.make({
			mass: isStatic ? 0 : 1,
			x: x * Const.PTM,
			y: y * Const.PTM,
			shapes: shapes
		});
		setPosPixel(x, y);

		body.on_move = (bx, by) -> {
			setPosPixel(bx * Const.MTP, by * Const.MTP);
			// invalidateDebugPhysShape = true;
		}

		if (!isStatic) {
			// game.delayer.addMs(null, () -> {
			PhysWorld.world.listen(body, PhysWorld.world.statics(), {separate: true});
			PhysWorld.world.listen(body, PhysWorld.world.dynamics(), {separate: true});
			// }, 0.01);
		}
	}

	override function postUpdate() {
		super.postUpdate();

		#if debug
		if (Console.ME.hasFlag(F_PhysicsShapes) || Console.ME.hasFlag(F_Bounds)){
			debug('BodyID=${body.id}');
		}
		#end
	}

	override function dispose() {
		super.dispose();

		body.dispose();
	}
}
