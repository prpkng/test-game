package en.bs.snooker;

import en.bs.snooker.st.ShotBallsState;
import echo.math.Vector2;
import tools.fsm.FSM;

class SnookerBoss extends Entity {
    private var fsm:FSM;

    public var desiredBallCount = 4;
    public var currentBalls:Array<SnookerBall> = [];
    public var levelCenter:Vector2;

    public function new(center: Vector2) {
        super(0, 0);
        levelCenter = center;
        fsm = new FSM([
            "populateBalls" => new PopulateBallsState(this),
            "shotBalls" => new ShotBallsState(this),
            "idle" => new State(false, null, t -> trace("Idle State")),
        ]);
        fsm.setStartState("populateBalls");
        fsm.debugMode = true;

        trace("Setting up boss");
        fsm.onEnter();
    }

    override function frameUpdate() {
        super.frameUpdate();
        fsm.update(tmod);
    }
}