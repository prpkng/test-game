package en.vfx;

import haxe.ds.Vector;
import hxease.Linear;
import hxease.Cubic;
import hxease.IEasing;
import h2d.col.Point;
import h2d.Graphics;
import h2d.Object;

using GM;

typedef TrailPoint = {
	point:h2d.col.Point,
	lifetime:Float
}

class Trail extends Entity {
	var graphics:Graphics;

	var addingDelay = 3;

	var points:Array<TrailPoint> = [];

	var trailLifetimeFrames = 30;

	var sizeEase:IEasing;
	var trailColor:Col;

	public static function create(parent:Object, color: Col, lifetimeFrames:Int, addingDelay:Int) {
		var trail = new Trail(parent);

		trail.noSprite();
		trail.trailColor = color.withAlphaIfMissing();
		trail.graphics = new Graphics(parent);
		trail.trailLifetimeFrames = lifetimeFrames;
		trail.addingDelay = addingDelay;
		trail.sizeEase = Linear.easeNone;
        return trail;
	}

	public function new(parent:Object) {
		super(0, 0);

		noSprite();
		graphics = new Graphics(parent);

		sizeEase = Linear.easeNone;
	}

	function addPoint() {
		points.insert(0, {
			point: new Point(graphics.parent.x, graphics.parent.y),
			lifetime: trailLifetimeFrames
		});
	}

	var addCounter = 0.0;

	override function preUpdate() {
		super.preUpdate();
		addCounter += tmod;
		if (addCounter > addingDelay) {
			addCounter = 0;

			addPoint();
		}

		var queuedRemoval:Array<TrailPoint> = [];
		for (point in points) {
			point.lifetime -= tmod;

			if (point.lifetime < 0)
				queuedRemoval.push(point);
		}
		for (point in queuedRemoval)
			points.remove(point);
	}

	override function frameUpdate() {
		graphics.clear();

		graphics.beginFill();
		var lastX = 0.0;
		var lastY = 0.0;

		var postPoints = new Vector(points.length+1, new Point(0, 0));
		var i = 0;

		var addV = (x, y) -> {
			graphics.addVertex(x, y, trailColor.rf, trailColor.gf, trailColor.bf, 255);
		}

		for (point in points) {
			var curX = point.point.x - graphics.parent.x;
			var curY = point.point.y - graphics.parent.y;

			var dir = new Point(curX - lastX, curY - lastY).normalized().perp();

			var lineSize = sizeEase.calculate(point.lifetime / trailLifetimeFrames) * 8 / 2;

            if (i == 0) {
                addV(0 + dir.x * lineSize, 0 + dir.y * lineSize);
                postPoints[points.length - 1] = new Point(0 - dir.x * lineSize, 0 - dir.y * lineSize);
                i++;
            }

			addV(curX + dir.x * lineSize, curY + dir.y * lineSize);
			postPoints[points.length +1- i] = new Point(curX - dir.x * lineSize, curY - dir.y * lineSize);

			lastX = curX;
			lastY = curY;
			i++;
		}

		for (point in postPoints) {
			addV(point.x, point.y);
		}

		graphics.endFill();
	}
}
