package en.bs.snooker.st;

import echo.data.Types.ForceType;
import echo.math.Vector2;
import tools.fsm.FSM;

class ShotBallsState extends FSM {

    var selectedBall: SnookerBall;

    public function new(boss: SnookerBoss) {
        super([
            "selectBall" => new tools.fsm.FSM.State(true, () -> {
                var selectedBall = R.pick(boss.currentBalls);
                var a = R.rnd(0, 360) * M.DEG_RAD;
                var dir = new Vector2(Math.cos(a), Math.sin(a));
                selectedBall.body.push(dir.x * 512, dir.y * 512, false, ForceType.VELOCITY);
            }),
            "moveToBall" => new tools.fsm.FSM.State(true, () -> {
                trace("Move to ball");
            })
        ]);
    }
}