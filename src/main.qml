import QtQuick.Window 2.2
import QtQuick 2.5
import QtGraphicalEffects 1.0


Window {

    id : window

    Component.onCompleted:
        {
            if(Qt.platform.os !== "android" && Qt.platform.os !== "ios" && Qt.platform.os !== "tvos")
            {
                width = 800
                height = 480
            }


    }

    property bool modelSceneEnabled: Qt.platform.os != "android" && Qt.platform.os != "ios"

    // 3d model scene not loaded on android/ios due to issues when overdrawing on top of the scene
    Timer
    {
         interval: 150; running: modelSceneEnabled ; repeat: false
        onTriggered: {
            var component = Qt.createComponent("ModelScene.qml");
            var scene = component.createObject(window,
                                           {
                                               "z": -1,
                                               "width": Math.min(img.width /divider, img.height / divider),
                                               "height": Math.min(img.width /divider, img.height / divider),
                                               "anchors.verticalCenter":  img.verticalCenter,
                                               "anchors.right": img.right
                                           }

                                           );
        }
    }

    visible: true // required, else it will be invisible

    property real divider : 1.5;


    // background color same as Scene3D clear color
    color: Qt.rgba(0.2, 0.8, 1, 1)


    Image
    {
        visible: modelSceneEnabled // this 2d animated submarine is used instead of model scene on android and ios
        id : submarine
        width : boatWindow.width * 0.2
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images2/orangeSubmarine.svg"
        anchors.verticalCenter : img.verticalCenter
        anchors.right : parent.right

        ParallelAnimation {
                    id: xAnim
                    // Animations on properties start running by default
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: submarine
                        property: "anchors.rightMargin"
                        from : 0.5* Screen.width; to : -200; duration: 5000; easing.type: Easing.Linear }

                    ScaleAnimator {
                                  target: submarine
                                  from: 4
                                  to: 1
                                  duration: 5000
                              }
                }
    }


    Image
    {
        id : img
        source: "qrc:/menu_images/woodTile.svg"
        anchors.fill: parent
        fillMode: Image.Tile
           layer.enabled: true
           layer.effect: OpacityMask {
               invert : true
               maskSource: Item {
                   width: img.width
                   height: img.height

                   Rectangle {
                       anchors.verticalCenter:  parent.verticalCenter
                       anchors.right: parent.right
                       anchors.rightMargin: 90/ 2  * Math.min(img.width , img.height) / 390
                       width: Math.min(img.width , img.height)/divider- 90  *Math.min(img.width , img.height) / 390
                       height: width
                       radius: Math.min(width, height)
                   }
               }
           }
    }

    // this image always vanishes as soon as ModelScene is rendered
    Image
    {
        id : boatWindow
        source : "qrc:/menu_images/boatWindow.svg"
        anchors.verticalCenter:  img.verticalCenter
        anchors.right: img.right
        width: Math.min(img.width /divider, img.height / divider)
        height: width
    }

    Image
    {
        id : boatsWindow
        source : "qrc:/menu_images/boatsWheel.svg"
        width: Math.min(img.width /divider, img.height / divider)
        height: width
        anchors.verticalCenter:  img.verticalCenter
        anchors.left: img.left

        SequentialAnimation
        {
            running: true

            loops: Animation.Infinite

            RotationAnimator {
                      target: boatsWindow;
                      from: 0;
                      to: 360;
                      duration: 3000
                      easing.type : Easing.InOutQuad

                  }
            RotationAnimator {
                      target: boatsWindow;
                      from: 360;
                      to: 0;
                      duration: 3000
                      easing.type : Easing.InOutQuad
                  }
        }
    }

    Image
    {
        id : playButton
        source: "qrc:/menu_images/playButton.svg"
        width: Math.min(img.width /divider, img.height / divider)/3
        height: width
        opacity: 0
        anchors.horizontalCenter:  img.horizontalCenter

        MouseArea{
            anchors.fill: parent
            onClicked: {

                GraphicsView.show();
                window.hide();
            }
        }

        property real yFraction: 0.0

        onYFractionChanged:
        {
            y = yFraction * img.height
        }

        ParallelAnimation
        {
            running: true


                      NumberAnimation{
                      property : "yFraction"
                      target: playButton;
                      from: 0.0;
                      to: 0.4;
                      duration: 1500
                      easing.type : Easing.OutBounce
                      }

        OpacityAnimator {
                  target: playButton;
                  from: 0.1;
                  to: 0.9;
                  duration: 2000
              }

        }

    }

}
