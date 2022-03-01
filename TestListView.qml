import QtQuick 2.0
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models


Rectangle {
    id: listViewRoot

    property alias model: visualModel.model
    property alias visualModel: visualModel
    property alias delegate: visualModel.delegate

    function selectedItems() {
        var indexes = []
        for (let i = 0; i < selectedGroup.count; i++) {
            indexes.push(selectedGroup.get(i).itemsIndex)
        }
        console.log(indexes)
        return indexes
    }

    ListView {
        id: listview

        property int currentSelectedIndex: -1
        property double autoscrollGap: 60
        property point dragPosition
        property bool containsInternalDrag
        property bool containsExternalDrag: false
        property int prevCount


        anchors.fill: parent
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        highlightMoveDuration: -1
        highlightMoveVelocity: 200
        headerPositioning: ListView.OverlayHeader
        model: visualModel
        populate: Transition {
            id: _popuTrans

            SequentialAnimation {
                PropertyAction { property: "scale"; value: 0.0 }
                PauseAnimation { duration: 25 * _popuTrans.ViewTransition.index }
                NumberAnimation { property: "scale"; from: 0.0; to: 1.0; duration: 100; easing.type: Easing.InOutQuad }
            }
        }


        add: Transition {
            enabled: true

            NumberAnimation { property: "scale"; from: 0; to: 1; duration: 300; easing.type: Easing.OutSine; easing.amplitude: 1.1 }
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 300 }
        }

        addDisplaced: Transition {
            enabled: true

            NumberAnimation { properties: "x,y"; duration: 300 }
        }
    }

    DelegateModel {
        id: visualModel

        property bool containsInternalDrag

        groups: [
            DelegateModelGroup {
                id: selectedGroup
                name: "selected"
            }
        ]

        delegate: ColumnLayout {
            id: delegateItem

            property string filePath: "2"
            width: listview.width
            height: 15
            spacing: 0



            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    id: dragRect

                    width: delegateItem.width
                    height: 15
                    color: delegateItem.DelegateModel.inSelected ? "red" : "transparent"


                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    Row {
                        anchors.fill: parent
                        leftPadding: 24
                        spacing: 24


                        Text {
                            id: idText
                            width: delegateItem.width / 3 * 2
                            anchors.verticalCenter: parent.verticalCenter
                            elide: Text.ElideRight
                            text: value
                        }

                    }
                }

                MouseArea {
                    id: mouseArea

                    // property int visualIndex: delegateItem.DelegateModel.itemsIndex

                    anchors.fill: parent
                    propagateComposedEvents: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton


                    onPressed: (mouse) => {
                                   if (mouse.button === Qt.LeftButton) {
                                       if (mouse.modifiers & Qt.ControlModifier) {
                                           delegateItem.DelegateModel.inSelected = !delegateItem.DelegateModel.inSelected;
                                       } else if (mouse.modifiers & Qt.ShiftModifier) {
                                           let from = listview.currentIndex, to = index;

                                           if (to < from) { [to, from] = [from, to]; }

                                           for (let i = from; i <= to; i++) {
                                               visualModel.items.get(i).inSelected = true;
                                           }
                                       } else {
                                           if (selectedGroup.count == 1) {
                                               selectedGroup.remove(0, selectedGroup.count);
                                           }

                                           delegateItem.DelegateModel.inSelected = true;
                                       }
                                   }
                               }

                    onReleased: (mouse) => {
                                    const usedControlOrShift = mouse.modifiers & (Qt.ShiftModifier | Qt.ControlModifier)

                                    if (!drag.active){
                                        if (selectedGroup.count > 0 && !usedControlOrShift) {
                                            selectedGroup.remove(0, selectedGroup.count );
                                            delegateItem.DelegateModel.inSelected = true;
                                        }
                                    }
                                }

                }

            }

        }
    }

}
