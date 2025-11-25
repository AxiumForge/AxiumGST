package viewer;

import h3d.Vector;
import h3d.prim.Cube;
import h3d.scene.Mesh;
import h3d.scene.Object;
import h3d.scene.fwd.DirLight;
import h3d.scene.fwd.LightSystem;
import hxd.App;
import hxd.Key;
import format.GstFormat;
import format.GaussianSplat;
import sys.io.File;

class ViewerMain extends App {
    var cameraSpeed = 10.;
    var rotSpeed = 3.;

    override function init() {
        super.init();

        var lightSystem:LightSystem = cast s3d.lightSystem;
        if (lightSystem != null) {
            lightSystem.ambientLight.set(0.2, 0.2, 0.2);
            new DirLight(new Vector(0.3, -0.8, -0.5), s3d);
        }

        setupCamera();
        loadGstData("assets/spiral.gst");
    }

    function setupCamera() {
        var cam = s3d.camera;
        cam.fovY = 60;
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

            var splatContainer = new Object(s3d);

            for (splat in gstFormat.splats) {
                var cube = new Cube(0.1, 0.1, 0.1);
                cube.addNormals(); // required for lit materials
                var mesh = new Mesh(cube, null, splatContainer);
                mesh.x = splat.x;
                mesh.y = splat.y;
                mesh.z = splat.z;

                mesh.material.color.set(splat.r / 255.0, splat.g / 255.0, splat.b / 255.0, splat.a / 255.0);
            }
        } catch (e:Dynamic) {
            trace('Error loading GST data: ${e}');
        }
    }

    override function update(dt:Float) {
        super.update(dt);

        var moveSpeed = cameraSpeed * dt;
        var rot = rotSpeed * dt;

        var forward = 0.0;
        var strafe = 0.0;
        var vertical = 0.0;

        if (Key.isDown(Key.W)) forward += moveSpeed;
        if (Key.isDown(Key.S)) forward -= moveSpeed;
        if (Key.isDown(Key.D)) strafe += moveSpeed;
        if (Key.isDown(Key.A)) strafe -= moveSpeed;
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
    }
    
    static function main() {
        new ViewerMain();
    }
}
