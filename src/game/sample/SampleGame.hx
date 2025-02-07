package sample;

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

		var circ = new en.PhysObject(256, -32).body;
		circ.add_shape(Shape.circle(0, 0, 48 * Const.PTM));
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
