package en;

import echo.math.Vector2;
import dn.Cooldown;

/**
 * A class representing the player current weapon
 */
class PlayerWeapon extends HSprite {
	/** The owning player **/
	var player:MainPlayer;

	/** Object pivot to keep the weapon object free from player transforms **/
	var gunPivot:h2d.Object;

	/** Cooldown Manager **/
	var cd:Cooldown;

	/** Fire rate in shots per second **/
	var fireRate:Float = 5;
	
	
	var isHoldingFire:Bool;

	public function new(parent:MainPlayer) {
		gunPivot = new h2d.Object(parent.spr);
		super(Assets.playerGun, "Idle", 0, gunPivot);

		player = parent;

		cd = new Cooldown(Const.FPS);

		// setPivotCoord(16-2, 16-3);
		setPivotCoord(16 - 3, 16);
		x = 2 - 3;
		y = 3;
		// setCenterRatio(0.5, 0.5);
	}

	public function update() {
		var localMouseX = player.cursor.attachX - player.spr.x;
		var localMouseY = player.cursor.attachY - player.spr.y;

		var a = Math.atan2(localMouseY, localMouseX);

		rotation = a;
		scaleY = localMouseX < 0 ? -1 : 1;
		player.sprScaleX = localMouseX < 0 ? -1 : 1;
		gunPivot.scaleX = player.sprScaleX;

		cd.update(player.game.tmod);

		if (isHoldingFire && !cd.has("Fire")) {
			fire();
		}
	}

	public function startFiring() {
		isHoldingFire = true;
		if (cd.has("Fire")) {
			return;
		}

		fire();
	}

	public function stopFiring() {
		isHoldingFire = false;
	}

	function fire() {
		cd.setS("Fire", 1.0 / fireRate);

		var cursor = player.cursor;
		cursor.setSquashX(0.65);
		cursor.setSquashY(0.65);

		cursor.shakeS(.75, .75, .25);

		var dir = new Vector2(cursor.attachX - player.attachX, cursor.attachY - player.attachY);

		new PlayerBullet(player, dir);
	}
}
