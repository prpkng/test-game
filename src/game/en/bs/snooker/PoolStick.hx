package en.bs.snooker;

class PoolStick extends Entity {
    var boss: SnookerBoss;

    var isFollowingHand = false;
    final FOLLOW_FRAMES = 8.0;

    public function new(boss: SnookerBoss) {
        super(0, 0, Const.DP_FRONT);
        this.boss = boss;

        // Assets.snookerBoss.poolStick.
        // trace();

        spr.set(Assets.snookerBoss.poolStick, "Stick", 0);
        spr.setPivotCoord(320, 5);
        followHand();
    }

    public function followHand() {
        isFollowingHand = true;
    }

    public function stopFollowHand() {
        isFollowingHand = false;
    }

    override function frameUpdate() {
        super.frameUpdate();

        if (isFollowingHand) {
            var x = boss.leftHand.attachX + 16;
            var y = boss.leftHand.attachY + 24;

            setPosPixel(
                M.lerp(attachX, x, tmod / FOLLOW_FRAMES),
                M.lerp(attachY, y, tmod / FOLLOW_FRAMES)
            );

            spr.rotation = M.lerp(spr.rotation, 50 * M.DEG_RAD, tmod / FOLLOW_FRAMES);
        }
    }
}