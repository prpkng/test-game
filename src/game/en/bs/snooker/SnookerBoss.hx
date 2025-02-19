package en.bs.snooker;

import en.bs.snooker.st.ShotBallsState;
import echo.math.Vector2;
import tools.fsm.FSM;

class SnookerBoss extends Entity {
    private var fsm:FSM;

    public var desiredBallCount = 4;
    public var currentBalls:Array<SnookerBall> = [];
    public var levelCenter:Vector2;

    public var leftHand:Hand;
    public var rightHand:Hand;
    public var poolStick:PoolStick;

    public function new(center: Vector2) {
        super(0, 0);
        levelCenter = center;
        var handOrigin = levelCenter - Vector2.up * 192;
        setPosPixel(handOrigin.x, handOrigin.y);


        poolStick = new PoolStick(this);
        rightHand = new Hand(false, handOrigin + Vector2.left * 32);
        leftHand = new Hand(true, handOrigin + Vector2.right * 32);

        fsm = new FSM([
            "populateBalls" => new PopulateBallsState(this),
            "shotBalls" => new ShotBallsState(this),
            "idle" => new State(false, null, t -> trace("Idle State")),
        ]);
        fsm.setStartState("populateBalls");
        fsm.debugMode = true;

        fsm.onEnter();
    }

    override function frameUpdate() {
        super.frameUpdate();
        fsm.update(tmod);
    }
}