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

		var circ = new en.PhysObject(256, 256).body;
		circ.add_shape(Shape.circle(0, 0, 48 * Const.PTM));
		var rect = new en.PhysObject(256, 256+128, true).body;
		rect.add_shape(Shape.rect(0, 0, 128 * Const.PTM, 16 * Const.PTM));
	
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
