package viewer;

import h3d.Vector;
import h3d.scene.Mesh;
import h3d.scene.Object;
import h3d.scene.fwd.DirLight;
import h3d.scene.fwd.LightSystem;
import hxd.App;
import hxd.Key;
import format.GstFormat;
import format.GaussianSplat;
import sys.io.File;

// New imports for instancing and shader
import h3d.prim.Instanced;
import h3d.impl.InstanceBuffer;
import h3d.Buffer.BufferFormat;
import h3d.prim.Plane2D;
import viewer.SplatShader; // Our custom shader
import h3d.Engine; // For screenResolution

class ViewerMain extends App {
    var cameraSpeed = 10.;
    var rotSpeed = 3.;
    var splatsMesh: Mesh; // To hold our instanced splats
    var splatShader: SplatShader; // Reference to our shader

    override function init() {
        super.init();

        var lightSystem:LightSystem = cast s3d.lightSystem;
        if (lightSystem != null) {
            lightSystem.ambientLight.set(0.2, 0.2, 0.2);
            new DirLight(new Vector(0.3, -0.8, -0.5), s3d);
        }

        setupCamera();
        loadGstData("assets/spiral.gst"); // This will now set up instanced rendering
    }

    function setupCamera() {
        var cam = s3d.camera;
        cam.fovY = 60 * (Math.PI / 180); // Convert to radians
        cam.zNear = 0.1;
        cam.zFar = 1000;
        cam.pos.set(0, -20, 10);
        cam.target.set(0, 0, 0);
        cam.up.set(0, 0, 1);
        cam.update();
    }

    function moveCamera(forward:Float, right:Float, up:Float) {
        if (forward == 0 && right == 0 && up == 0) return;

        var cam = s3d.camera;
        var delta = new Vector();

        if (forward != 0) {
            var fwd = cam.getForward();
            fwd.scale(forward);
            delta = delta.add(fwd);
        }
        if (right != 0) {
            var r = cam.getRight();
            r.scale(right);
            delta = delta.add(r);
        }
        if (up != 0) {
            var u = cam.getUp();
            u.scale(up);
            delta = delta.add(u);
        }

        cam.pos = cam.pos.add(delta);
        cam.target = cam.target.add(delta);
        cam.update();
    }

    function rotateCamera(yawDelta:Float, pitchDelta:Float) {
        if (yawDelta == 0 && pitchDelta == 0) return;

        var cam = s3d.camera;
        var dir = cam.target.sub(cam.pos);
        var radius = dir.length();

        var yaw = Math.atan2(dir.y, dir.x) + yawDelta;
        var pitch = Math.atan2(dir.z, Math.sqrt(dir.x * dir.x + dir.y * dir.y)) + pitchDelta;
        var maxPitch = Math.PI * 0.499;
        if (pitch > maxPitch) pitch = maxPitch;
        if (pitch < -maxPitch) pitch = -maxPitch;

        var cosPitch = Math.cos(pitch);
        dir.set(Math.cos(yaw) * cosPitch, Math.sin(yaw) * cosPitch, Math.sin(pitch));
        dir.scale(radius);

        cam.target = cam.pos.add(dir);
        cam.up.set(0, 0, 1);
        cam.update();
    }

    function loadGstData(path:String):Void {
        trace("Loading GST data from " + path);
        try {
            var bytes = File.getBytes(path);
            var gstFormat = GstFormat.fromBytes(bytes);
            trace("Loaded " + gstFormat.splats.length + " splats.");

            var instanceCount = gstFormat.splats.length;

            // Define the format for per-instance data: Position (Vec3), Color (Vec4), Scale (Float)
            var instanceDataFormats = [
                { name: "instancePos", format: BufferFormat.F32x3, perInstance: true },
                { name: "instanceColor", format: BufferFormat.F32x4, perInstance: true },
                { name: "instanceScale", format: BufferFormat.F32, perInstance: true }
                // Add rotation (Mat4 or Vec4) later if needed for full Gaussian
            ];

            // Create the InstanceBuffer
            // 3 floats for pos + 4 floats for color + 1 float for scale = 8 floats per instance
            var instanceBuffer = new InstanceBuffer(instanceCount, instanceDataFormats);
            var instanceData = new haxe.ds.Vector<Float>(instanceCount * 8);

            for (i in 0...instanceCount) {
                var splat = gstFormat.splats[i];
                var offset = i * 8;

                // Position (Vec3)
                instanceData[offset + 0] = splat.x;
                instanceData[offset + 1] = splat.y;
                instanceData[offset + 2] = splat.z;

                // Color (Vec4) - normalized
                instanceData[offset + 3] = splat.r / 255.0;
                instanceData[offset + 4] = splat.g / 255.0;
                instanceData[offset + 5] = splat.b / 255.0;
                instanceData[offset + 6] = splat.a / 255.0;

                // Scale (Float) - using splat.scaleX for uniform scale for now
                instanceData[offset + 7] = splat.scaleX;
            }
            instanceBuffer.upload(instanceData);

            // Create a simple quad as the base primitive to be instanced
            var basePrimitive = new Plane2D();

            // Create the Instanced primitive and link the instance buffer
            var instancedPrimitive = new Instanced();
            instancedPrimitive.setMesh(basePrimitive);
            instancedPrimitive.commands = instanceBuffer;

            // Create a Mesh to render the instanced primitive
            splatsMesh = new Mesh(instancedPrimitive, s3d);

            // Assign our custom shader
            splatShader = new SplatShader();
            splatsMesh.material.mainPass.shader = splatShader;

        } catch (e:Dynamic) {
            trace('Error loading GST data: ${e}');
        }
    }

    override function update(dt:Float) {
        super.update(dt);

        // Update camera controls
        var moveSpeed = cameraSpeed * dt;
        var rot = rotSpeed * dt;

        var forward = 0.0;
        var strafe = 0.0;
        var vertical = 0.0;

        if (Key.isDown(Key.W)) forward += moveSpeed;
        if (Key.isDown(Key.S)) forward -= moveSpeed;
        if (Key.isDown(Key.A)) strafe -= moveSpeed;
        if (Key.isDown(Key.D)) strafe += moveSpeed;
        if (Key.isDown(Key.E)) vertical += moveSpeed;
        if (Key.isDown(Key.Q)) vertical -= moveSpeed;
        moveCamera(forward, strafe, vertical);

        var yaw = 0.0;
        var pitch = 0.0;
        if (Key.isDown(Key.LEFT)) yaw += rot;
        if (Key.isDown(Key.RIGHT)) yaw -= rot;
        if (Key.isDown(Key.UP)) pitch += rot;
        if (Key.isDown(Key.DOWN)) pitch -= rot;
        rotateCamera(yaw, pitch);

        // Update shader uniforms
        if (splatShader != null) {
            splatShader.cameraMatrix.set(s3d.camera.getViewProj());
            splatShader.screenResolution.set(s3d.engine.width, s3d.engine.height);
        }
    }
    
    static function main() {
        new ViewerMain();
    }
}
