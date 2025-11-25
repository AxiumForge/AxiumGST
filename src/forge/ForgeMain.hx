package forge;

import forge.data.PlyParser;
import format.GaussianSplat;
import format.GstFormat;
import haxe.zip.Compress;
import haxe.zip.Uncompress;
import Sys;
import sys.io.File;
import format.JDAFormat;
import haxe.Json; // Used for JDA metadata, specifically Date.now().toString()
import haxe.Timer; // Used for Date.now()

class ForgeMain {
    public static function main() {
        trace("AxiumForge CLI");

        var args = Sys.args();

        if (args.length > 0) {
            switch (args[0]) {
                case "ingest-ply":
                    if (args.length >= 3) {
                        var inputPlyPath = args[1];
                        var outputGstPath = args[2];
                        ingestPly(inputPlyPath, outputGstPath);
                    } else {
                        trace("Usage: ingest-ply <input_ply_file.ply> <output_gst_file.gst>");
                    }
                case "generate-spiral":
                    if (args.length >= 2) {
                        var outputGstPath = args[1];
                        generateSpiralSplats(outputGstPath);
                    } else {
                        trace("Usage: generate-spiral <output_gst_file.gst>");
                    }
                case "compress":
                    if (args.length >= 3) {
                        var inputGstPath = args[1];
                        var outputGstPath = args[2];
                        compressGst(inputGstPath, outputGstPath);
                    } else {
                        trace("Usage: compress <input_gst_file.gst> <output_gst_file.gst>");
                    }
                case "uncompress":
                    if (args.length >= 3) {
                        var inputGstPath = args[1];
                        var outputGstPath = args[2];
                        uncompressGst(inputGstPath, outputGstPath);
                    } else {
                        trace("Usage: uncompress <input_gst_file.gst> <output_gst_file.gst>");
                    }
                case "encapsulate-jda":
                    if (args.length >= 4) {
                        var inputGstPath = args[1];
                        var outputJdaPath = args[2];
                        var assetName = args[3];
                        encapsulateJDA(inputGstPath, outputJdaPath, assetName);
                    } else {
                        trace("Usage: encapsulate-jda <input_gst_file.gst> <output_jda_file.jda> <asset_name>");
                    }
                case "decapsulate-jda":
                    if (args.length >= 3) {
                        var inputJdaPath = args[1];
                        var outputGstPath = args[2];
                        decapsulateJDA(inputJdaPath, outputGstPath);
                    } else {
                        trace("Usage: decapsulate-jda <input_jda_file.jda> <output_gst_file.gst>");
                    }
                default:
                    trace("Unknown command: " + args[0]);
                    trace("Available commands: ingest-ply, generate-spiral, compress, uncompress, encapsulate-jda, decapsulate-jda");
            }
        } else {
            trace("No command provided. Available commands: ingest-ply, generate-spiral, compress, uncompress, encapsulate-jda, decapsulate-jda");
            // Default action if no arguments: generate a spiral for convenience
            generateSpiralSplats("assets/spiral.gst");
        }
    }

    static function generateSpiralSplats(outputPath:String):Void {
        trace("Generating spiral Gaussian splats to " + outputPath);

        var gstFormat = new GstFormat();

        var numSplats = 1000;
        var radius = 10.0;
        var turns = 3.0;
        var height = 20.0;

        for (i in 0...numSplats) {
            var t = i / numSplats; // Normalized progress (0 to 1)

            var angle = turns * Math.PI * 2 * t;
            var currentRadius = radius * (1 - t); // Spiral inwards

            var x = currentRadius * Math.cos(angle);
            var y = currentRadius * Math.sin(angle);
            var z = height * t - (height / 2); // Center around 0

            // Simple color interpolation from blue to red
            var r = Std.int(255 * t);
            var g = 0;
            var b = Std.int(255 * (1 - t));
            var a = 255;

            // Simple scale and rotation (for now, uniform scale, no rotation)
            var scaleX = 0.5;
            var scaleY = 0.5;
            var scaleZ = 0.5;
            var rotW = 1.0; var rotX = 0.0; var rotY = 0.0; var rotZ = 0.0; // Identity quaternion

            var splat = new GaussianSplat(x, y, z, r, g, b, a, scaleX, scaleY, scaleZ, rotW, rotX, rotY, rotZ);
            gstFormat.addSplat(splat);
        }

        var bytes = gstFormat.toBytes();
        File.saveBytes(outputPath, bytes);

        trace("Generated " + numSplats + " splats.");
    }

    static function ingestPly(inputPlyPath:String, outputGstPath:String):Void {
        trace("Ingesting PLY file: " + inputPlyPath);
        try {
            var splats = PlyParser.parse(inputPlyPath);
            if (splats.length > 0) {
                var gstFormat = new GstFormat();
                for (splat in splats) {
                    gstFormat.addSplat(splat);
                }
                var bytes = gstFormat.toBytes();
                File.saveBytes(outputGstPath, bytes);
                trace("Successfully ingested " + splats.length + " splats from PLY to " + outputGstPath);
            } else {
                trace("No splats found in PLY file.");
            }
        } catch (e:Dynamic) {
            trace('Error ingesting PLY file: ${e}');
        }
    }

    static function compressGst(inputGstPath:String, outputGstPath:String):Void {
        trace("Compressing GST file: " + inputGstPath + " to " + outputGstPath);
        try {
            var inputBytes = File.getBytes(inputGstPath);
            var compressedBytes = Compress.run(inputBytes, 9); // 9 is max compression level
            File.saveBytes(outputGstPath, compressedBytes);
            trace("Successfully compressed GST file to " + outputGstPath);
        } catch (e:Dynamic) {
            trace('Error compressing GST file: ${e}');
        }
    }

    static function uncompressGst(inputGstPath:String, outputGstPath:String):Void {
        trace("Uncompressing GST file: " + inputGstPath + " to " + outputGstPath);
        try {
            var inputBytes = File.getBytes(inputGstPath);
            var uncompressedBytes = Uncompress.run(inputBytes);
            File.saveBytes(outputGstPath, uncompressedBytes);
            trace("Successfully uncompressed GST file to " + outputGstPath);
        } catch (e:Dynamic) {
            trace('Error uncompressing GST file: ${e}');
        }
    }

    static function encapsulateJDA(inputGstPath:String, outputJdaPath:String, assetName:String):Void {
        trace("Encapsulating GST file: " + inputGstPath + " into JDA: " + outputJdaPath);
        try {
            var gstBytes = File.getBytes(inputGstPath);
            var metadata = {
                name: assetName,
                source: inputGstPath,
                timestamp: Date.now().toString()
            };
            var jdaString = JDAFormat.create("GaussianSplat", metadata, gstBytes);
            File.saveContent(outputJdaPath, jdaString);
            trace("Successfully encapsulated GST file into JDA: " + outputJdaPath);
        } catch (e:Dynamic) {
            trace('Error encapsulating JDA: ${e}');
        }
    }

    static function decapsulateJDA(inputJdaPath:String, outputGstPath:String):Void {
        trace("Decapsulating JDA file: " + inputJdaPath + " to GST: " + outputGstPath);
        try {
            var jdaString = File.getContent(inputJdaPath);
            var jdaData = JDAFormat.extract(jdaString);
            File.saveBytes(outputGstPath, jdaData.gstBytes);
            trace("Successfully decapsulated JDA to GST: " + outputGstPath + " (Asset Type: " + jdaData.assetType + ", Name: " + jdaData.metadata.name + ")");
        } catch (e:Dynamic) {
            trace('Error decapsulating JDA: ${e}');
        }
    }
}
