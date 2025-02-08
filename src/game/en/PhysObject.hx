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
		trace('${(body.x)},${(body.y)}');
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

		#if debug
		spr.colorize(0, 0);
		#end
	}

	#if debug
	function enableDebugPhysShape() {
		if (debugPhysShape == null) {
			debugPhysShape = new Graphics(spr);
			invalidateDebugPhysShape = true;
		}
	}

	function disableDebugPhysShape() {
		if (debugPhysShape != null) {
			debugPhysShape.remove();
			debugPhysShape = null;
		}
	}

	function renderDebugPhysShape() {
		invalidateDebugPhysShape = false;

		debugPhysShape.clear();
		for (shape in body.shapes) {
			switch (shape.type) {
				case CIRCLE:
					var circ:Circle = cast shape;
					debugPhysShape.beginFill(0xff5050, 0.5);
					debugPhysShape.drawCircle(circ.local_x * Const.MTP, circ.local_y * Const.MTP, circ.radius * Const.MTP);
					debugPhysShape.endFill();
					debugPhysShape.lineStyle(2, 0xffaaaa, 0.75);
					debugPhysShape.moveTo(circ.local_x * Const.MTP, circ.local_y * Const.MTP);
					var right = new Vector2(1, 0).rotate(circ.rotation);
					debugPhysShape.lineTo(circ.local_x * Const.MTP + right.x * (circ.radius * Const.MTP),
						circ.local_y * Const.MTP + right.y * (circ.radius * Const.MTP));
					debugPhysShape.setColor(0xffaaaa, 0.75);
					debugPhysShape.drawCircle(circ.local_x * Const.MTP, circ.local_y * Const.MTP, circ.radius * Const.MTP);
				case RECT:
					var rect:Rect = cast shape;
					debugPhysShape.beginFill(0xff5050, 0.5);
					debugPhysShape.drawRect(shape.local_x * Const.MTP - rect.width / 2 * Const.MTP, shape.local_y * Const.MTP - rect.height / 2 * Const.MTP,
						rect.width * Const.MTP, rect.height * Const.MTP);
					debugPhysShape.endFill();
					debugPhysShape.lineStyle(2, 0xffaaaa, 0.75);
					debugPhysShape.moveTo(shape.local_x * Const.MTP, shape.local_y * Const.MTP);
					var right = new Vector2(1, 0).rotate(shape.rotation);
					debugPhysShape.lineTo(shape.local_x * Const.MTP + right.x * (rect.width / 2 * Const.MTP),
						shape.local_y * Const.MTP + right.y * (rect.width / 2 * Const.MTP));
					debugPhysShape.setColor(0xffaaaa, 0.75);
					debugPhysShape.drawRect(shape.local_x * Const.MTP - rect.width / 2 * Const.MTP, shape.local_y * Const.MTP - rect.height / 2 * Const.MTP,
						rect.width * Const.MTP, rect.height * Const.MTP);
				// break;
				case _:
					continue;
			}
		}
	}
	#end

	override function preUpdate() {
		super.preUpdate();
		#if debug
		if (Console.ME.hasFlag(ConsoleFlag.F_PhysicsShapes) && debugPhysShape == null) {
			enableDebugPhysShape();
		} else if (!Console.ME.hasFlag(ConsoleFlag.F_PhysicsShapes) && debugPhysShape != null) {
			disableDebugPhysShape();
		}
		#end
	}

	override function postUpdate() {
		super.postUpdate();
		#if debug
		if (debugPhysShape != null && invalidateDebugPhysShape) {
			renderDebugPhysShape();
		}
		#end
	}
}
