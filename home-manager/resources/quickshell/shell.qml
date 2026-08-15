import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Scope {
  id: root

  property bool barVisible: true
  property string clockText: Qt.formatDateTime(new Date(), "HH:mm:ss")

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.clockText = Qt.formatDateTime(new Date(), "HH:mm:ss")
  }

  Process {
    id: launcher
    command: ["rofi", "-show", "drun"]
    running: false
  }

  IpcHandler {
    target: "bar"

    function toggle(): void {
      root.barVisible = !root.barVisible
    }
  }

  IpcHandler {
    target: "launcher"

    function toggle(): void {
      launcher.running = true
    }
  }

  // These handlers keep the existing Hyprland keybindings harmless until
  // their full desktop integrations are added to the shell.
  IpcHandler {
    target: "notifications"

    function dismiss_all(): void {}
    function dnd_toggle(): void {}
  }

  IpcHandler {
    target: "media"

    function toggle(): void {}
    function play_pause(): void {}
  }

  IpcHandler {
    target: "wallpaper"

    function toggle(): void {}
  }

  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        required property var modelData

        screen: modelData
        visible: root.barVisible
        implicitHeight: 34
        exclusiveZone: 34

        anchors {
          top: true
          left: true
          right: true
        }

        Rectangle {
          anchors.fill: parent
          color: "#282828"
          border.color: "#85ad85"
          border.width: 1
        }

        RowLayout {
          anchors.fill: parent
          anchors.leftMargin: 10
          anchors.rightMargin: 10
          spacing: 12

          Text {
            color: "#85ad85"
            font.bold: true
            font.pixelSize: 16
            text: "NixOS"
          }

          Text {
            color: "#d4be98"
            font.pixelSize: 13
            text: "Hyprland"
          }

          Item {
            Layout.fillWidth: true
          }

          Text {
            color: "#ebdbb2"
            font.family: "monospace"
            font.pixelSize: 13
            text: root.clockText
          }
        }
      }
    }
  }
}
