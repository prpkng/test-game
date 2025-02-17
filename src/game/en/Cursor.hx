package en;

import h2d.col.Point;

class Cursor extends Entity {
	var player:MainPlayer;

	var gamepadLookDistance = 64;
	var gamepadAnalogMag = 0.0;
	var gamepadAnalogDir = new Point();
	var isUsingGamepad = false;

	var lastMousePos = new Point();

	public function new(player:MainPlayer) {
		super(0, 0, Const.DP_MAX);

		this.player = player;
		spr.set(Assets.uiAtlas, "Crosshair");
		spr.setCenterRatio(0.5, 0.5);

		this.disableDebugBounds();
	}

	override function preUpdate() {
		super.preUpdate();

		var mp = new Point(hxd.Window.getInstance().mouseX, hxd.Window.getInstance().mouseY);

		if (player.ca.getPadLeftStickDist() > 0 || player.ca.getPadRightStickDist() > 0) {
			isUsingGamepad = true;
		} else if (lastMousePos.x != mp.x || lastMousePos.y != mp.y) {
			isUsingGamepad = false;
		}
		lastMousePos = mp;
	}

	override function frameUpdate() {
		#if debug
		game.hud.debug('MP: ${(M.round(camera.worldMouseX))},${M.round(camera.worldMouseY)}');
		game.hud.debug('MP (GRID): ${(M.round(camera.worldMouseX/Const.GRID))},${M.round(camera.worldMouseY/Const.GRID)}');
		#end
		if (isUsingGamepad) {
			var dist = player.ca.getAnalogDistXY(LookX, LookY);
			if (dist > 0) {
				var angle = player.ca.getAnalogAngleXY(LookX, LookY);
				gamepadAnalogDir.x = Math.cos(angle);
				gamepadAnalogDir.y = Math.sin(angle);
			} else if (player.ca.getAnalogDist4(MoveLeft, MoveRight, MoveUp, MoveDown) > 0.05) {
				var angle = player.ca.getAnalogAngle4(MoveLeft, MoveRight, MoveUp, MoveDown);
				gamepadAnalogDir.x = Math.cos(angle);
				gamepadAnalogDir.y = Math.sin(angle);
				dist = 0.25;
			}

			gamepadAnalogMag = M.lerp(gamepadAnalogMag, Math.max(dist, .025), tmod / 4.0);
			spr.alpha = M.lerp(-0.5, 1.0, gamepadAnalogMag);
			
			setPosPixel(gamepadAnalogDir.x * gamepadLookDistance * gamepadAnalogMag + player.attachX,
				gamepadAnalogDir.y * gamepadLookDistance * gamepadAnalogMag + player.attachY);
			} else {
			spr.alpha = 1; 
			setPosPixel(camera.worldMouseX, camera.worldMouseY);
		}
	}
}
