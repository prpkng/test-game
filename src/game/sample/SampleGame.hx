package sample;

import dn.heaps.filter.Crt;
import echo.math.Vector2;
import en.bs.snooker.SnookerBall;
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

		app.scene.filter = new Crt(3, 0xffffff, 0.35);

		new PhysWorld();
		new MainPlayer();

		var levelCenter = Vector2.zero;
		if (level is LDtkLevel) {
			var center = (cast(level, LDtkLevel)).data.l_Entities.all_CenterMarker[0];
			levelCenter.set(center.pixelX, center.pixelY);
		}

		new en.PhysObject(levelCenter.x, levelCenter.y, true, [
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
			var ball = new SnookerBall(R.rnd(levelCenter.x - 128, levelCenter.x + 128), R.rnd(levelCenter.y - 128, levelCenter.y + 128));
			ball.body.material.elasticity = 0.9;
			var randAngle = R.rnd(0, 360) * M.DEG_RAD;
			var force = 240;
			ball.body.push(
				Math.cos(randAngle) * force, 
				Math.sin(randAngle) * force, 
				false, 
				ForceType.VELOCITY
			);
		}
	}

	override function preUpdate() {
		hud.clearDebug();
		super.preUpdate();

		if (engine.fps < 30) {
			for (_ in 0...3) {
				PhysWorld.ME?.update((1.0 / engine.fps / 3) * tmod);
			}
		}
		else 
			PhysWorld.ME?.update((1.0 / engine.fps) * tmod);
	}

	override function fixedUpdate() {
		super.fixedUpdate();

	}

	override function onDispose() {
		super.onDispose();

		PhysWorld.ME?.dispose();
	}
}
