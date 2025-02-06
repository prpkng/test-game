package en;

import h2d.col.Point;
import dn.heaps.filter.PixelOutline;
import h3d.Vector;


class PlayerBullet extends Entity {

    var bulletSpeed = 1.95;
    var moveDir:Vector;

    public function new(player: TopDownPlayer, dir:Vector) {
        super(0, 0);
        dir.normalize();
        setPosPixel(player.attachX + dir.x * 8, player.attachY + 3 + dir.y * 6);

        vBase.setFricts(0, 0);
        moveDir = dir;

        spr.set(Assets.mainAtlas, "Bullet");
        spr.rotation = Math.atan2(dir.y, dir.x);
        spr.filter = new PixelOutline(0xffffffff);
        spr.setCenterRatio(0.5, 0.5);
    }

    override function fixedUpdate() {
        super.fixedUpdate();

        vBase.dx = moveDir.x * bulletSpeed;
        vBase.dy = moveDir.y * bulletSpeed;
    }
}