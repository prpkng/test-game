package en;

import echo.math.Vector2;
import h2d.Object;
import en.vfx.Trail;
import dn.heaps.filter.PixelOutline;

class PlayerBullet extends Entity {
	static public var ALL:FixedArray<PlayerBullet> = new FixedArray<PlayerBullet>(16);

	var bulletSpeed = 0.975;
	var moveDir:Vector2;

	var trail:Trail;
	var bulletSprite:HSprite;


	public function new(player:MainPlayer, dir:Vector2) {
		super(player.cx, player.cy);
		if (dir.length_sq < 0.05) {
			dispose();
			return;
		}
		ALL.push(this);
		dir.normalize();
		setPosPixel(player.attachX + dir.x * 4, player.attachY + 3 + dir.y * 4);
		vBase.setFricts(0, 0);
		moveDir = dir;

		// noSprite();
        spr.colorize(Col.white(), 0.0);
        

		bulletSprite = new HSprite(Assets.mainAtlas, "Bullet", spr);
		bulletSprite.rotation = Math.atan2(dir.y, dir.x);
		bulletSprite.filter = new PixelOutline(0x4e2b45);
		bulletSprite.setCenterRatio(0.5, 0.5);
		postUpdate();
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


