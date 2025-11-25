package format;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;

class GaussianSplat {
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var r:Int; // 0-255
    public var g:Int; // 0-255
    public var b:Int; // 0-255
    public var a:Int; // 0-255 (opacity)
    public var scaleX:Float;
    public var scaleY:Float;
    public var scaleZ:Float;
    public var rotW:Float; // Quaternion W
    public var rotX:Float; // Quaternion X
    public var rotY:Float; // Quaternion Y
    public var rotZ:Float; // Quaternion Z

    public function new(x:Float, y:Float, z:Float, r:Int, g:Int, b:Int, a:Int, scaleX:Float, scaleY:Float, scaleZ:Float, rotW:Float, rotX:Float, rotY:Float, rotZ:Float) {
        this.x = x; this.y = y; this.z = z;
        this.r = r; this.g = g; this.b = b; this.a = a;
        this.scaleX = scaleX; this.scaleY = scaleY; this.scaleZ = scaleZ;
        this.rotW = rotW; this.rotX = rotX; this.rotY = rotY; this.rotZ = rotZ;
    }

    public static function fromBytes(input:BytesInput):GaussianSplat {
        var x = input.readFloat();
        var y = input.readFloat();
        var z = input.readFloat();
        var r = input.readByte();
        var g = input.readByte();
        var b = input.readByte();
        var a = input.readByte();
        var scaleX = input.readFloat();
        var scaleY = input.readFloat();
        var scaleZ = input.readFloat();
        var rotW = input.readFloat();
        var rotX = input.readFloat();
        var rotY = input.readFloat();
        var rotZ = input.readFloat();
        return new GaussianSplat(x, y, z, r, g, b, a, scaleX, scaleY, scaleZ, rotW, rotX, rotY, rotZ);
    }

    public function toBytes(output:BytesOutput):Void {
        output.writeFloat(x);
        output.writeFloat(y);
        output.writeFloat(z);
        output.writeByte(r);
        output.writeByte(g);
        output.writeByte(b);
        output.writeByte(a);
        output.writeFloat(scaleX);
        output.writeFloat(scaleY);
        output.writeFloat(scaleZ);
        output.writeFloat(rotW);
        output.writeFloat(rotX);
        output.writeFloat(rotY);
        output.writeFloat(rotZ);
    }
}
