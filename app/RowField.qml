import QtQuick 2.0
import Ubuntu.Components 1.1

TextField {
    id: root
    property alias title: label.text

    width: parent.width

    primaryItem: Label {
        id: label
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.bold: true
    }

    readOnly: true
    hasClearButton: false
    activeFocusOnPress: false
}
