package en.bs.snooker;

import aseprite.res.Aseprite;

class Hand extends Entity {

    var isLeftHand:Bool;

    public function new(isLeft:Bool) {
        isLeftHand = isLeft;

        super(0, 0, Const.DP_FRONT);

        spr.set(Assets.snookerBoss.hands, "Idle");
        spr.setCenterRatio(0.5, 0.5);

        if (!isLeft)
            sprScaleX = -1;

    }
    
    override function frameUpdate() {
        super.frameUpdate();
    }
    
}