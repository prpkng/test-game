package en.bs.snooker;

import echo.math.Vector2;
import aseprite.res.Aseprite;

class Hand extends Entity {

    final SINE_X_FREQ:Float = 2;
    final SINE_X_AMP:Float = 8;
    final SINE_Y_FREQ:Float = 1;
    final SINE_Y_AMP:Float = 16;

    var isLeftHand:Bool;
    var isSineActive = false;
    var timeCounter = 0.0;

    var startPos:Vector2;



    public function new(isLeft:Bool, startPos:Vector2) {
        isLeftHand = isLeft;

        super(0, 0, Const.DP_FRONT);

        this.startPos = startPos;

        spr.set(Assets.snookerBoss.hands, "Idle");
        spr.setCenterRatio(0.5, 0.5);

        if (!isLeft)
            sprScaleX = -1;

        startSine();
    }

    public function startSine() {
        isSineActive = true;
    }

    public function stopSine() {
        isSineActive = false;
    }

    
    override function frameUpdate() {
        super.frameUpdate();
 
        if (!isSineActive)
            return;


        timeCounter += tmod / Const.FPS;

        var x = Math.sin(timeCounter * SINE_X_FREQ) * SINE_X_AMP * (isLeftHand ? 1 : -1);
        var y = Math.sin(timeCounter * SINE_Y_FREQ) * SINE_Y_AMP;

        setPosPixel(startPos.x + x, startPos.y + y);
    }
    
}