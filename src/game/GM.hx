class GM {
    public static inline function inverseLerp(x:Float, a:Float, b:Float):Float {
        return (x - a) / (b - a);
    }

    public static inline function vecText(x:Float, y:Float): String {
        return '(${x}, ${y})';
    }
}