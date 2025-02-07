package en.bs.snooker;

class SnookerBall extends PhysObject {
    public function new(x:Float,y:Float) {
        super(x, y, false, [
            {
                type: CIRCLE,
                radius: 24 * Const.PTM
            }
        ]);

        spr.set(Assets.lineBall);
    }
}