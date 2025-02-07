import h2d.Graphics;

class Letterboxing extends AppChildProcess {
	var graphics:Graphics;
	var letterboxing:h2d.Layers;

	public function new() {
		super();
		createRootInLayers(app.root, Const.DP_MAX);

		// letterboxing = new h2d.Layers();
		// root.add(letterboxing, Const.DP_MAX);
		// letterboxing.filter = new h2d.filter.Nothing();
		// letterboxing.x *= Const.SCALE;
		// letterboxing.y *= Const.SCALE;
		// letterboxing.setScale(Const.SCALE);

		// graphics = new Graphics(letterboxing);
		// graphics.beginFill(0x000000);
		// graphics.drawRect(-400 - 200, 0, 200, 225);
		// graphics.drawRect(400, 0, 200, 225);
		// graphics.drawRect(-400 - 200, -225, 200 + 400 + 200, 225);
		// graphics.drawRect(-400 - 200, 0, 200 + 400 + 200, 225);
		// graphics.endFill();

        calculateBounds();
	}

    function calculateBounds() {
        var s = app.scene;
        
        var w:Float = s.width;
        var h:Float = s.height;
        if (w / 16.0 > h / 9.0) {
            w = h / 9.0 * 16.0;
        }else if (h / 9.0 > w / 16.0) {
            h = w / 16.0 * 9.0;
        }
        s.renderer.clipRenderZone((s.width - w) / 2, (s.height - h) / 2, w, h);
    }

    override function update() {
        super.update();

        app.scene.renderer.popRenderZone();
        calculateBounds();
        // s.renderer.clipRenderZone((s.width - 400) / 2, (s.height - 225) / 2, 400, 225);
    }
}
