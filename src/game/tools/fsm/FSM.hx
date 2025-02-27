package tools.fsm;

import haxe.Exception;
import haxe.ds.Map;
import haxe.macro.Expr;

/**
 * The wrapper interface for all elements throughout the state-machine
 */
interface IState {
	/**
	 * Read-only reference to the owning fsm
	 */
	public var fsm(get, never):FSM;

	/**
	 * Called whenever the fsm enters this state
	 */
	public function onEnter():Void;

	/**
	 * Called whenever the fsm exits from this state to another one
	 */
	public function onExit():Void;

	/**
	 * Called from the fsm on the custom user-specified update loop
	 * @param tmod The ration between the current FPS and the desired FPS (60)
	 */
	public function update(tmod:Float):Void;

	/**
	 * Called from a state machine to put this state in the tree
	 */
	public function setParent(parent:FSM):Void;

    public function canExit():Bool;
}

/**
 * The base type for all leaf states
 */
class StateBase implements IState {
	public var _fsm:FSM;

	public var fsm(get, never):FSM;
    public var hasExitTime = false;
    public var canSafelyExit = false;

    public function new(hasExitTime:Bool = false) {
        this.hasExitTime = hasExitTime;
    }

    public function canExit():Bool {
        return hasExitTime ? canSafelyExit : true;
    }

	public function get_fsm():FSM {
		return _fsm;
	}

	public function setParent(parent:FSM) {
		_fsm = parent;
	}

	public function onEnter() {}

	public function onExit() {
        canSafelyExit = false;
    }

	public function update(tmod:Float) {}
}

class State extends StateBase {
	/**
	 * Creates a new generic state with anonymous functions defining its steps
	 * @param onEnter Called whenever the fsm enters this state
	 * @param onExit Called whenever the fsm exits from this state to another one
	 * @param update Called from the fsm on the custom user-specified update loop
	 */
	public function new(hasExitTime:Bool = false, ?onEnter:Null<() -> Void>, ?update:Null<(tmod:Float) -> Void>, ?onExit:Null<() -> Void>) {
		super(hasExitTime);
        if (onEnter != null)
			this._onEnter = onEnter;
		if (update != null)
			this._update = update;
		if (onExit != null)
			this._onExit = onExit;
	}

	dynamic function _onEnter() {}

	public override function onEnter() {
		_onEnter();
	}

	dynamic function _onExit() {}

	public override function onExit() {
        super.onExit();
		_onExit();
	}

	dynamic function _update(tmod:Float) {}

	public override function update(tmod:Float) {
		_update(tmod);
	}
}

class FSM implements IState {
	var parent:Null<FSM>;

	var states:Map<String, IState> = new Map();
    var currentStateName:Null<String>;
    
    var currentState(get, never):IState;
    function get_currentState():IState {
        return states.get(currentStateName);
    }

    var requestedTransition:Null<String>;
    
	public var startState:String;

	public var fsm(get, never):FSM;
    public var hasExitTime = false;
    public var canSafelyExit = false;

	public function get_fsm():FSM {
		return parent ?? this;
	}

	public var debugMode = false;

	public function new(?initialStates:Null<Map<String, IState>>, hasExitTime = false) {
        this.hasExitTime = hasExitTime;
		for (id => state in initialStates) {
			states.set(id, state);
			state.setParent(this);
            startState = id;
		}
	}

	public function setStartState(idx:String) {
		if (!states.exists(idx)) {
            throw new Exception('No state found in FSM named: ${idx}');
        }
        startState = idx;
        onEnter();
	}

    public function requestTransition(to: String, delay = 0.0) {
		if (!states.exists(to)) {
            throw new Exception('No state found in FSM named: ${to}');
        }
		if (delay == 0)
        	requestedTransition = to;
		else 
			Game.ME.delayer.addS(null, () -> requestedTransition = to, delay);
    } 

    public function canExit():Bool {
        return hasExitTime ? canSafelyExit : true;
    }

	public function setParent(fsm:FSM) {
		parent = fsm;
	}

	public function onEnter() {
        if (currentStateName == null) {
            if (startState == null) return;
            requestTransition(startState);
            return;
        }
        currentState.onEnter();
    }

	public function onExit() {
        currentState.onExit();
    }

	public function update(tmod:Float) {
		if (debugMode)
			Game.ME.hud.debug('Current state: ${currentStateName}');

        if (requestedTransition != null) {
            if (states.exists(currentStateName))
                currentState.onExit();
            currentStateName = requestedTransition;
            requestedTransition = null;
            currentState.onEnter();

			if (debugMode)
				Game.ME.hud.notify('Boss state: "${currentStateName}"', 0x0a0a0a);
        }
        if (states.exists(currentStateName)) {
            currentState.update(tmod);
        }
    }
}
