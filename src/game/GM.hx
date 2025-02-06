import h2d.col.Point;

class GM {
    public static inline function inverseLerp(x:Float, a:Float, b:Float):Float {
        return (x - a) / (b - a);
    }

    public static inline function vecText(x:Float, y:Float): String {
        return '(${x}, ${y})';
    }

    public static function perp(p:Point) {
        return new Point(p.y, -p.x);
    }
}