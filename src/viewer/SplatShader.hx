package viewer;

import hxsl.Shader;

class SplatShader extends Shader {
    static var SRC = {
        @input var position: Vec3; // (-0.5, -0.5, 0) to (0.5, 0.5, 0) for a quad

        @param var center: Vec3;
        @param var color: Vec4;
        @param var scale: Float; // Use a single float for uniform scale

        @param var cameraMatrix: Mat4; // View-Projection Matrix
        @param var screenResolution: Vec2; // Screen width, height

        var output: {
            position: Vec4,
            color: Vec4,
            uv: Vec2
        };

        function vertex() {
            // Transform instance position to clip space
            var clipCenter = vec4(center, 1.0) * cameraMatrix;

            // Calculate screen-space size for the quad based on projected scale
            // This is a simplified projection, real Gaussian splatting is more complex
            var screenScale = scale * 10.0; // Arbitrary factor for visibility

            // Offset the quad corners in screen space
            var screenOffset = vec2(position.x * screenScale / screenResolution.x,
                                    position.y * screenScale / screenResolution.y);

            // Add screen-space offset to clip-space center
            output.position = vec4(clipCenter.xy + screenOffset * clipCenter.w, clipCenter.z, clipCenter.w);
            output.color = color;
            output.uv = position.xy + 0.5; // UVs for a quad (0,0 to 1,1)
        }

        function fragment() {
            // Simple circle for a Gaussian "splat" for now
            var dist = length(output.uv - 0.5);
            var alpha = max(0.0, 1.0 - dist * 2.0); // Simple circular falloff

            output.color = vec4(output.color.rgb, output.color.a * alpha);
        }
    }
}
