package viewer;

import hxsl.BaseShader; // Correct import for base shader
import h3d.Vector; // For Vec3, Vec4, Vec2
import h3d.Matrix; // For Mat4

class SplatShader extends BaseShader { // Extend BaseShader

    @input var position: Vec3; // (-0.5, -0.5, 0) to (0.5, 0.5, 0) for a quad

    @input var instancePos: Vec3;
    @input var instanceColor: Vec4;
    @input var instanceScale: Float; // Use a single float for uniform scale
    // @input var instanceRotation: Vec4; // Quaternion for later

    @param var cameraMatrix: Mat4; // View-Projection Matrix
    @param var screenResolution: Vec2; // Screen width, height

    var output: {
        color: Vec4,
        uv: Vec2
    };

    function __init__() {
        instanceColor = vec4(1.0, 1.0, 1.0, 1.0);
        instanceScale = 1.0;
    }

    @:vertex
    function vertex() {
        // Transform instance position to clip space
        var clipCenter = vec4(instancePos, 1.0) * cameraMatrix;

        // Calculate screen-space size for the quad based on projected scale
        // This is a simplified projection, real Gaussian splatting is more complex
        var screenScale = instanceScale * 10.0; // Arbitrary factor for visibility

        // Offset the quad corners in screen space
        var screenOffset = vec2(position.x * screenScale / screenResolution.x,
                                position.y * screenScale / screenResolution.y);

        // Add screen-space offset to clip-space center
        out.glPosition = vec4(clipCenter.xy + screenOffset * clipCenter.w, clipCenter.z, clipCenter.w);
        output.color = instanceColor;
        output.uv = position.xy + 0.5; // UVs for a quad (0,0 to 1,1)
    }

    @:fragment
    function fragment() {
        // Simple circle for a Gaussian "splat" for now
        var dist = length(output.uv - 0.5);
        var alpha = max(0.0, 1.0 - dist * 2.0); // Simple circular falloff

        output.color = vec4(output.color.rgb, output.color.a * alpha);
    }
}
