package en;

/**
 * A class representing the player current weapon
 */
class PlayerWeapon extends HSprite {
	var player:TopDownPlayer;
	var gunPivot:h2d.Object;

	public function new(parent:TopDownPlayer) {
		gunPivot = new h2d.Object(parent.spr);
		super(Assets.playerGun, "Idle", 0, gunPivot);

		player = parent;
		
		
		// setPivotCoord(16-2, 16-3);
		setPivotCoord(16-3, 16);
		x = 2-3; y = 3;
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
	}
}
