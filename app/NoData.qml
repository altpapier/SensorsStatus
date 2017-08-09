import QtQuick 2.0
import Ubuntu.Components 1.1

Label {
    id: noResult
    objectName: "noResult"
    width: parent.width-units.gu(6)
    anchors.centerIn: parent
    fontSize: "medium"
    wrapMode: Text.WordWrap
    horizontalAlignment: Text.AlignHCenter
    text: i18n.tr('No data available')
}
