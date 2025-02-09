class LDtkLevel extends Level {
	public var data : World_Level;
	var tilesetSource : h2d.Tile;

	public var marks : dn.MarkerMap<LevelMark>;

	public function new(ldtkLevel:World.World_Level) {
		super();


		data = ldtkLevel;
		cWid = data.l_Collisions.cWid;
		cHei = data.l_Collisions.cHei;
		pxWid = cWid * Const.GRID;
		pxHei = cHei * Const.GRID;
		tilesetSource = hxd.Res.levels.worldTiles.toAseprite().toTile();

		marks = new dn.MarkerMap(cWid, cHei);
		for(cy in 0...cHei)
		for(cx in 0...cWid) {
			if( data.l_Collisions.getInt(cx,cy)==1 )
				marks.set(M_Coll_Wall, cx,cy);
		}
	}

	override function onDispose() {
		super.onDispose();
		data = null;
		tilesetSource = null;
		marks.dispose();
		marks = null;
	}

	/** Return TRUE if "Collisions" layer contains a collision value **/
	public override function hasCollision(cx,cy) : Bool {
		return !isValid(cx,cy) ? true : marks.has(M_Coll_Wall, cx,cy);
	}

	/** Render current level**/
	override function render() {
		// Placeholder level render
		root.removeChildren();

		var tg = new h2d.TileGroup(tilesetSource, root);
		// data.l_Collisions.render(tg);
		
		data.l_TilesBG.render(tg);
		data.l_TilesTop.render(tg);
	}

	override function postUpdate() {
		super.postUpdate();

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}