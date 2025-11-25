package format;

import haxe.Json;
import haxe.io.Bytes;
import haxe.crypto.Base64;

class JDAFormat {
    public static function create(assetType:String, metadata:Dynamic, gstBytes:Bytes):String {
        var jda:Dynamic = {
            assetType: assetType,
            version: 1,
            metadata: metadata,
            binaryData: Base64.encode(gstBytes).toString()
        };
        return Json.stringify(jda, null, "  ");
    }

    public static function extract(jdaString:String):{assetType:String, metadata:Dynamic, gstBytes:Bytes} {
        var jda:Dynamic = Json.parse(jdaString);
        var assetType:String = jda.assetType;
        var version:Int = jda.version; // Can be used for versioning logic
        var metadata:Dynamic = jda.metadata;
        var binaryDataString:String = jda.binaryData;

        if (assetType == null || metadata == null || binaryDataString == null) {
            throw "Invalid JDA format: Missing required fields.";
        }

        var gstBytes:Bytes = Base64.decode(binaryDataString); // Corrected this line

        return {assetType: assetType, metadata: metadata, gstBytes: gstBytes};
    }
}
