package en;

import h3d.Vector;

class Cursor extends Entity {
	var player:TopDownPlayer;

    var gamepadLookDistance = 64;
	var isUsingGamepad = false;

	var lastMousePos = new Vector();

	public function new(player:TopDownPlayer) {
		super(0, 0);

		this.player = player;
		spr.set(Assets.uiAtlas, "Crosshair");
		spr.setCenterRatio(0.5, 0.5);

		this.disableDebugBounds();
	}

	override function preUpdate() {
		super.preUpdate();

		var mp = new Vector(camera.worldMouseX, camera.worldMouseY);

		if (player.ca.getPadLeftStickDist() > 0 || player.ca.getPadRightStickDist() > 0) {
			isUsingGamepad = true;
		} else if (mp != lastMousePos) {
			isUsingGamepad = false;
		}
		lastMousePos = mp;
	}

	override function frameUpdate() {
		if (isUsingGamepad) {
            var angle = player.ca.getAnalogAngleXY(LookX, LookY);
            var dirX = Math.cos(angle);
			var dirY = Math.sin(angle);
            setPosPixel(dirX * gamepadLookDistance + player.attachX, dirY * gamepadLookDistance + player.attachY);
        } else {
			setPosPixel(lastMousePos.x, lastMousePos.y);
		}
	}
}
