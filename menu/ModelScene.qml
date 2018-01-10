import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

Entity {
    id: sceneRoot

    property vector3d modelRotationAngles: Qt.vector3d(180,30,0)

    Camera {
        id: camera
        projectionType: CameraLens.PerspectiveProjection
        fieldOfView: 45
        aspectRatio: 4/3
        nearPlane : 0.1
        farPlane : 1000.0
        position: Qt.vector3d( 0.0, 0.0, -20.0 )
        upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
        viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
    }

//    OrbitCameraController {
//        camera: camera
//    }

    components: [
        RenderSettings {
            activeFrameGraph: ForwardRenderer {
                clearColor: Qt.rgba(0, 0.5, 1, 1)
                camera: camera
            }
        },
        // Event Source will be set by the Qt3DQuickWindow
        InputSettings { }
    ]

    PhongMaterial {
        id: material
    }

    Transform {
        id: torusTransform
        property real userAngle: 0.0
        scale3D: Qt.vector3d(1.0, 1, 1.0)
        matrix: {
                    var m = Qt.matrix4x4();
                    m.rotate(modelRotationAngles.x, Qt.vector3d(1, 0, 0));
                    m.rotate(modelRotationAngles.y, Qt.vector3d(0, 1, 0));
                    m.rotate(modelRotationAngles.z, Qt.vector3d(0, 0, 1));
                    return m;
                }
    }

    QQ2.NumberAnimation {
        target: torusTransform
        property: "userAngle"
        duration: 10000
        from: 0
        to: 360

        loops: QQ2.Animation.Infinite
        running: true
    }

    Entity {
        id: torusEntity

       Mesh {
           id: mesh
           source: "qrc:/models/submarine.obj"
       }

        components: [ mesh, material, torusTransform ]
    }

    SphereMesh {
        id: sphereMesh
        radius: 3
    }


}
