class Level extends GameChildProcess {
	/** Level grid-based width**/
	public var cWid(default,null): Int;
	/** Level grid-based height **/
	public var cHei(default,null): Int;

	/** Level pixel width**/
	public var pxWid(default,null) : Int;
	/** Level pixel height**/
	public var pxHei(default,null) : Int;

	var invalidated = true;

	public function new() {
		super();

		createRootInLayers(Game.ME.scroller, Const.DP_BG);
	}

	override function onDispose() {
		super.onDispose();
	}

	/** TRUE if given coords are in level bounds **/
	public inline function isValid(cx,cy) return cx>=0 && cx<cWid && cy>=0 && cy<cHei;

	/** Gets the integer ID of a given level grid coord **/
	public inline function coordId(cx,cy) return cx + cy*cWid;

	/** Ask for a level render that will only happen at the end of the current frame. **/
	public inline function invalidate() {
		invalidated = true;
	}

	/** Return TRUE if "Collisions" layer contains a collision value **/
	public function hasCollision(cx,cy) : Bool {
		return false;
	}

	/** Render current level**/
	function render() {
		// Placeholder level render
		// root.removeChildren();
	}

	override function postUpdate() {
		super.postUpdate();

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}