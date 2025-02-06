package en;

/**
	SamplePlayer is an Entity with some extra functionalities:
	- user controlled (using gamepad or keyboard)
	- falls with gravity
	- has basic level collisions
	- some squash animations, because it's cheap and they do the job
**/
class TopDownPlayer extends Entity {
	public var ca:ControllerAccess<GameAction>;

	var hSpeed = 0.;
	var vSpeed = 0.;
	var moveSpeed = 0.195;

	var moving(get, never):Bool;

	inline function get_moving() {
		return hSpeed != 0 || vSpeed != 0;
	}

	var playerWeapon:PlayerWeapon;

	public function new() {
		super(5, 5);

		// Start point using level entity "PlayerStart"
		var start = level.data.l_Entities.all_PlayerStart[0];
		if (start != null)
			setPosCase(start.cx, start.cy);

		// Misc inits
		vBase.setFricts(0.1, 0.1);

		// Camera tracks this
		camera.trackEntity(this, true);
		camera.clampToLevelBounds = true;

		// Init controller
		ca = App.ME.controller.createAccess();
		ca.lockCondition = Game.isGameControllerLocked;

		// Placeholder display
		spr.set(Assets.player, "Idle", 0);
		spr.anim.play("Idle");
		spr.anim.loop();
		spr.setCenterRatio(0.5, 0.5);
		pivotY = 0.5;

		// Player Gun
		playerWeapon = new PlayerWeapon(this);
	}

	override function dispose() {
		super.dispose();
		ca.dispose(); // don't forget to dispose controller accesses
	}

	/** X collisions **/
	override function onPreStepX() {
		super.onPreStepX();

		// Right collision
		if (xr > 0.6 && level.hasCollision(cx + 1, cy))
			xr = 0.6;

		// Left collision
		if (xr < 0.4 && level.hasCollision(cx - 1, cy))
			xr = 0.4;
	}

	/** Y collisions **/
	override function onPreStepY() {
		super.onPreStepY();

		// Land on ground
		if (yr > 0.6 && level.hasCollision(cx, cy + 1)) {
			yr = 0.6;
		}

		// Ceiling collision
		if (yr < 0.4 && level.hasCollision(cx, cy - 1))
			yr = 0.4;
	}

	/**
		Control inputs are checked at the beginning of the frame.
		VERY IMPORTANT NOTE: because game physics only occur during the `fixedUpdate` (at a constant 30 FPS), no physics increment should ever happen here! What this means is that you can SET a physics value (eg. see the Jump below), but not make any calculation that happens over multiple frames (eg. increment X speed when walking).
	**/
	override function preUpdate() {
		super.preUpdate();

		hSpeed = 0;
		vSpeed = 0;

		// Horizontal movement
		if (!isChargingAction() && ca.getAnalogDist2(MoveLeft, MoveRight) > 0) {
			hSpeed = ca.getAnalogValue2(MoveLeft, MoveRight); // -1 to 1
		}
		if (!isChargingAction() && ca.getAnalogDist2(MoveUp, MoveDown) > 0) {
			vSpeed = ca.getAnalogValue2(MoveUp, MoveDown); // -1 to 1
		}

		if (moving) {
			if (!spr.anim.isPlaying("Run"))
				spr.anim.playAndLoop("Run");
		} else {
			if (!spr.anim.isPlaying("Idle"))
				spr.anim.playAndLoop("Idle");
		}
	}

	override function frameUpdate() {
		super.frameUpdate();

		playerWeapon.update();
	}

	override function fixedUpdate() {
		super.fixedUpdate();

		// Apply requested walk movement

		if (hSpeed != 0)
			vBase.dx += hSpeed * moveSpeed;
		if (vSpeed != 0)
			vBase.dy += vSpeed * moveSpeed;
	}
}
