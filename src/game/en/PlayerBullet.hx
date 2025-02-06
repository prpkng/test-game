package en;

import h2d.Object;
import en.vfx.Trail;
import h2d.col.Point;
import dn.heaps.filter.PixelOutline;
import h3d.Vector;

class PlayerBullet extends Entity {
	var bulletSpeed = 1.95;
	var moveDir:Vector;

	var trail:Trail;
	var bulletSprite:HSprite;

	public function new(player:TopDownPlayer, dir:Vector) {
		super(0, 0);
		dir.normalize();
		setPosPixel(player.attachX + dir.x * 8, player.attachY + 3 + dir.y * 6);

		vBase.setFricts(0, 0);
		moveDir = dir;

		// noSprite();
        spr.colorize(Col.white(), 0.0);
        

		bulletSprite = new HSprite(Assets.mainAtlas, "Bullet", spr);
		bulletSprite.rotation = Math.atan2(dir.y, dir.x);
		bulletSprite.filter = new PixelOutline(0xffffffff);
		bulletSprite.setCenterRatio(0.5, 0.5);

		trail = Trail.create(spr, 8, 3);

        cd.setS("destroy", 1.5);
        cd.onComplete("destroy", () -> {
            dispose();
        });
	}

	override function fixedUpdate() {
        super.fixedUpdate();
        vBase.dx = moveDir.x * bulletSpeed;
		vBase.dy = moveDir.y * bulletSpeed;
	}
}
