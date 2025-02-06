package en;

class Cursor extends Entity {
    public function new() {
        super(0, 0);

        spr.set(Assets.uiAtlas, "Crosshair");
        spr.setCenterRatio(0.5, 0.5);
    }

    override function frameUpdate() {
        setPosPixel(camera.worldMouseX, camera.worldMouseY);
    }
}