import echo.Echo;

class PhysWorld {
    static public var ME: PhysWorld;
    static public var world(get, never):echo.World;
        static function get_world(): echo.World {
            return ME.activeWorld;
        }
    public var activeWorld: echo.World;

    public function new() {
        ME = this;

        activeWorld = Echo.start(
			{
				width: 1024,
				height: 1024,
                // gravity_y: 9.8 * Const.PTM
			}
		);
    }

    public function dispose() {
        ME = null;
        activeWorld.dispose();
    }

    public function update(step: Float, tmod: Float = 1) {
        activeWorld.step(step * tmod);
    }
}