package en.bs.snooker;

import tools.fsm.FSM.StateBase;

class PopulateBallsState extends StateBase {
    private var boss: SnookerBoss;
    public function new(boss: SnookerBoss) {
        super();

        this.boss = boss;
    }

    override function onEnter() {
        super.onEnter();
        
        for (i in 0...boss.desiredBallCount) {
            var x = R.rnd(boss.levelCenter.x - 128, boss.levelCenter.x + 128);
            var y = R.rnd(boss.levelCenter.y - 128, boss.levelCenter.y + 128);

            var ball = new SnookerBall(x, y);
            boss.currentBalls.push(ball);
        }

        fsm.requestTransition("shotBalls", 1);
    }
}