package en;

import h2d.Graphics;
import echo.Line;
import echo.math.Vector2;

class BoxCaster {
	public var parent:Null<Entity>;

	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;

	public var lines:FixedArray<Line> = new FixedArray<Line>(4);

	public function new(?parent:Entity, x:Float, y:Float, width:Float, height:Float) {
		this.parent = parent;

		setBoundsPixel(x, y, width, height);
	}

	public function setBoundsPixel(x:Float, y:Float, width:Float, height:Float) {
		setBounds(x * Const.PTM, y * Const.PTM, width * Const.PTM, height * Const.PTM);
	}

	public function setBounds(x:Float, y:Float, width:Float, height:Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;

		var ep = new Vector2(parent?.attachX ?? 0, parent?.attachY ?? 0) * Const.PTM;
		ep.x -= x;
		ep.y -= y;
		var topLeft = new Vector2(x + ep.x - width / 2, y + ep.y - height / 2);
		var topRight = new Vector2(x + ep.x + width / 2, y + ep.y - height / 2);
		var bottomRight = new Vector2(x + ep.x + width / 2, y + ep.y + height / 2);
		var bottomLeft = new Vector2(x + ep.x - width / 2, y + ep.y + height / 2);
        lines.empty();
        lines.push(Line.get_from_vectors(topLeft, bottomLeft));
        lines.push(Line.get_from_vectors(topRight, bottomRight));
        lines.push(Line.get_from_vectors(bottomLeft, bottomRight));
        lines.push(Line.get_from_vectors(topLeft, topRight));
	}

    
	#if debug
    
	var debugPhysShape:Null<Graphics>;
	var invalidateDebugPhysShape:Bool;
    
	function enableDebugPhysShape() {
		if (debugPhysShape == null) {
			debugPhysShape = new Graphics(parent?.spr ?? null);
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
        var world = PhysWorld.world;
        var dynamics = world.dynamics();
        for (line in lines) {

            debugPhysShape.lineStyle(1, 0xff6666);

            debugPhysShape.moveTo(line.start.x * Const.MTP, line.start.y * Const.MTP);
            debugPhysShape.lineTo(line.end.x * Const.MTP, line.end.y * Const.MTP);

            var intersect = line.linecast(dynamics, world);
            // if (intersect.) {

            // }
        }
	}
	#end

	public function check() {}
}
