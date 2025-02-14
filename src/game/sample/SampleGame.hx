package sample;

import en.bs.snooker.SnookerBoss;
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
		new PhysWorld();
		new MainPlayer();

		
		var levelCenter = Vector2.zero;
		if (level is LDtkLevel) {
			var center = (cast(level, LDtkLevel)).data.l_Entities.all_CenterMarker[0];
			levelCenter.set(center.pixelX, center.pixelY);
		}
		new SnookerBoss(levelCenter);

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
