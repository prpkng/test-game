package test;

import tools.fsm.FSM;
import utest.Assert;
import utest.UTest;
import utest.Test;

class TestRunner {
    public static function main() {
        UTest.run([new FSMTestCase()]);
    }
}


class FSMTestCase extends Test {
    public function testBasic() {
        var i = 0;
        var fsm = new FSM([
            "idle" => new tools.fsm.FSM.State(null, _ -> i++)
        ]);
        fsm.setStartState("idle");
        fsm.update(1);
        fsm.update(1);
        fsm.update(1);
        Assert.equals(3, i);
    }
    public function testNested() {
        var i = 0;
        var fsm = new FSM([
            "foo" => new FSM([
                "idle" => new tools.fsm.FSM.State(null, _ -> i+=2)
            ]),
            "bar" => new tools.fsm.FSM.State(null, _ -> i++)
        ]);
        fsm.setStartState("foo");
        fsm.update(1);
        fsm.update(1);
        fsm.update(1);
        Assert.equals(6, i);
    }
    public function testChange() {
        var i = 0;
        var fsm = new FSM([
            "foo" => new FSM([
                "idle" => new tools.fsm.FSM.State(null, _ -> i+=2)
            ]),
            "bar" => new tools.fsm.FSM.State(null, _ -> i++)
        ]);
        fsm.setStartState("foo");
        fsm.update(1);
        fsm.update(1);
        fsm.update(1);
        Assert.equals(6, i);
        fsm.requestTransition("bar");
        fsm.update(1);
        fsm.update(1);
        fsm.update(1);
        Assert.equals(9, i);
        fsm.requestTransition("foo");
        fsm.update(1);
        fsm.update(1);
        fsm.update(1);
        Assert.equals(15, i);
    }
}
