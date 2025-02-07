class Letterboxing extends AppChildProcess {

    public function new() {
        super();

        createRootInLayers(app.root, Const.DP_MAX);
    }
}