package en.bs.snooker;

import tools.fsm.FSM.StateBase;

class PopulateBallsState extends StateBase {
    private var boss: SnookerBoss;

    final MIN_TABLE_X = 19;
    final MAX_TABLE_X = 32;
    final MIN_TABLE_Y = 20;
    final MAX_TABLE_Y = 28;

    public function new(boss: SnookerBoss) {
        super();

        this.boss = boss;
    }

    override function onEnter() {
        super.onEnter();
        
        for (i in 0...boss.desiredBallCount) {
            var x = R.rnd(MIN_TABLE_X * Const.GRID, MAX_TABLE_X * Const.GRID);
            var y = R.rnd(MIN_TABLE_Y * Const.GRID, MAX_TABLE_Y * Const.GRID);

            var ball = new SnookerBall(x, y);
            boss.currentBalls.push(ball);
        }

        fsm.requestTransition("shotBalls", 1);
    }
}