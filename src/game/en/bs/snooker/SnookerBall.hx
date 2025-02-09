package en.bs.snooker;

class SnookerBall extends PhysObject {
    final VELOCITY_TO_ANIM_RATIO = 0.01125 * Const.MTP;
    final VELOCITY_TO_ANIM_POWER = 2;
    public function new(x:Float,y:Float) {
        super(x, y, false, [
            {
                type: CIRCLE,
                radius: 24 * Const.PTM
            }
        ]);

        spr.colorize(0xffffffff);
        spr.set(Assets.lineBall, "Spin");
        spr.setCenterRatio();
        spr.anim.playAndLoop("Spin");
    }


    override function postUpdate() {
        super.postUpdate();

        var vel = body.velocity;

        var a = Math.atan2(vel.y, vel.x);
        spr.rotation = a;

        spr.anim.setSpeed(Math.pow(vel.length * VELOCITY_TO_ANIM_RATIO, VELOCITY_TO_ANIM_POWER));
    }
}