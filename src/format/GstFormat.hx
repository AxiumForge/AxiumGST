package format;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import format.GaussianSplat; // Corrected import

class GstFormat {
    public var splats:Array<GaussianSplat>;

    public function new() {
        splats = [];
    }

    public function addSplat(splat:GaussianSplat):Void {
        splats.push(splat);
    }

    public function toBytes():Bytes {
        var output = new BytesOutput();
        // Magic number (e.g., "GST") and Version (e.g., 1)
        output.writeString("GST"); // 3 bytes
        output.writeByte(1);       // 1 byte for version
        output.writeInt32(splats.length); // Use writeInt32 for number of splats

        for (splat in splats) {
            splat.toBytes(output);
        }
        return output.getBytes();
    }

    public static function fromBytes(bytes:Bytes):GstFormat {
        var input = new BytesInput(bytes);
        var magic = input.readString(3);
        if (magic != "GST") {
            throw "Invalid GST format: Magic number mismatch";
        }
        var version = input.readByte();
        if (version != 1) {
            throw "Unsupported GST version: " + version;
        }
        var numSplats = input.readInt32(); // Use readInt32 for number of splats
        var format = new GstFormat();
        for (i in 0...numSplats) {
            format.addSplat(GaussianSplat.fromBytes(input));
        }
        return format;
    }
}
