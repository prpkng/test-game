package en;

import h2d.Object;
import en.vfx.Trail;
import h2d.col.Point;
import dn.heaps.filter.PixelOutline;
import h3d.Vector;

class PlayerBullet extends Entity {
	static public var ALL:FixedArray<PlayerBullet> = new FixedArray<PlayerBullet>(16);

	var bulletSpeed = 1.95;
	var moveDir:Vector;

	var trail:Trail;
	var bulletSprite:HSprite;


	public function new(player:MainPlayer, dir:Vector) {
		super(0, 0);
		if (dir.lengthSq() < 0.05) {
			dispose();
			return;
		}
		ALL.push(this);
		dir.normalize();
		setPosPixel(player.attachX + dir.x * 8, player.attachY + 3 + dir.y * 6);

		vBase.setFricts(0, 0);
		moveDir = dir;

		// noSprite();
        spr.colorize(Col.white(), 0.0);
        

		bulletSprite = new HSprite(Assets.mainAtlas, "Bullet", spr);
		bulletSprite.rotation = Math.atan2(dir.y, dir.x);
		bulletSprite.filter = new PixelOutline(0x4e2b45);
		bulletSprite.setCenterRatio(0.5, 0.5);

		trail = Trail.create(spr, Col.inlineHex("#ff4e2b45"), 8, 3);

        game.delayer.addS(null, () -> {
            dispose();
        }, 1.5);
		
	}

	override function fixedUpdate() {
		vBase.dx = moveDir.x * bulletSpeed;
		vBase.dy = moveDir.y * bulletSpeed;
        super.fixedUpdate();
	}

	override function dispose() {
		ALL.remove(this);
		super.dispose();
	}

}


