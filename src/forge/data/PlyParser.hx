package forge.data;

import haxe.io.Input;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import sys.io.File;
import format.GaussianSplat; // Corrected import
import StringTools;

class PlyParser {
    public static function parse(filePath:String):Array<GaussianSplat> {
        var splats:Array<GaussianSplat> = [];
        var input:Input = File.read(filePath, false); // Read as text for header

        var line:String;
        var headerEnded = false;
        var format:String = "ascii"; // Default to ascii
        var numVertices:Int = 0;
        var properties:Array<{name:String, type:String}> = [];

        try {
            // Parse header
            while ((line = input.readLine()) != null) {
                line = StringTools.trim(line);
                if (line == "end_header") {
                    headerEnded = true;
                    break;
                }
                if (StringTools.startsWith(line, "ply")) continue;
                if (StringTools.startsWith(line, "comment")) continue;

                var parts = line.split(" ");
                switch (parts[0]) {
                    case "format":
                        format = parts[1];
                        if (format != "ascii") {
                            throw "Only ASCII PLY format is currently supported.";
                        }
                    case "element":
                        if (parts[1] == "vertex") {
                            numVertices = Std.parseInt(parts[2]);
                        }
                    case "property":
                        if (parts.length >= 3) {
                            properties.push({name: parts[2], type: parts[1]});
                        }
                }
            }

            if (!headerEnded) {
                throw "Invalid PLY file: 'end_header' not found.";
            }
            if (numVertices == 0) {
                throw "No vertex elements found in PLY file.";
            }

            // Parse data section (for ASCII)
            for (i in 0...numVertices) {
                line = input.readLine();
                if (line == null) {
                    throw "Unexpected end of file while reading vertex data.";
                }
                var values = line.split(" ");

                var x = 0.0, y = 0.0, z = 0.0;
                var r = 255, g = 255, b = 255, a = 255;
                // Default scale and rotation (will be refined later)
                var scaleX = 1.0, scaleY = 1.0, scaleZ = 1.0;
                var rotW = 1.0, rotX = 0.0, rotY = 0.0, rotZ = 0.0;

                var valueIndex = 0;
                for (prop in properties) {
                    if (valueIndex >= values.length) break;

                    switch (prop.name) {
                        case "x": x = Std.parseFloat(values[valueIndex]);
                        case "y": y = Std.parseFloat(values[valueIndex]);
                        case "z": z = Std.parseFloat(values[valueIndex]);
                        case "red": r = Std.parseInt(values[valueIndex]);
                        case "green": g = Std.parseInt(values[valueIndex]);
                        case "blue": b = Std.parseInt(values[valueIndex]);
                        case "alpha": a = Std.parseInt(values[valueIndex]);
                    }
                    valueIndex++;
                }
                splats.push(new GaussianSplat(x, y, z, r, g, b, a, scaleX, scaleY, scaleZ, rotW, rotX, rotY, rotZ));
            }
        } catch (e:Dynamic) {
            trace('Error parsing PLY file: ${e}');
        }
        input.close();

        return splats;
    }
}
