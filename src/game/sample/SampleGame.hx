package sample;

import echo.data.Types.ForceType;
import dn.RandomTools;
import echo.Shape;
import echo.Echo;

/**
	This small class just creates a SamplePlayer instance in current level
**/
class SampleGame extends Game {
	public function new() {
		super();
	}
	

	override function startLevel() {
		super.startLevel();
		new PhysWorld();
		new TopDownPlayer();

		new en.PhysObject(304, 264, true, [
			{
				type: RECT,
				offset_y: -112 * Const.PTM,
				width: 448 * Const.PTM,
				height: 16 * Const.PTM
			},
			{
				type: RECT,
				offset_y: 112 * Const.PTM,
				width: 448 * Const.PTM,
				height: 16 * Const.PTM
			},
			{
				type: RECT,
				offset_x: -234 * Const.PTM,
				width: 16 * Const.PTM,
				height: 224 * Const.PTM
			},
			{
				type: RECT,
				offset_x: 234 * Const.PTM,
				width: 16 * Const.PTM,
				height: 224 * Const.PTM
			}
		]);

		for (i in 0...4) {
			var circ = new en.PhysObject(R.rnd(224.0, 384.0), R.rnd(208, 256)).body;
			circ.add_shape(Shape.circle(0, 0, 24 * Const.PTM));
			circ.material.elasticity = 1;
			var randAngle = R.rnd(0, 360) * M.DEG_RAD;
			var force = 3;
			circ.push(
				Math.cos(randAngle * force), 
				Math.sin(randAngle * force), 
				false, 
				ForceType.VELOCITY
			);
		}
	}

	override function preUpdate() {
		hud.clearDebug();
		super.preUpdate();
	}

	override function fixedUpdate() {
		super.fixedUpdate();

		PhysWorld.ME?.update(1.0 / 30.0);
	}

	override function onDispose() {
		super.onDispose();

		PhysWorld.ME?.dispose();
	}
}
