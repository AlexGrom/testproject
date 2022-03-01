import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import test

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")


    RowLayout {
        TestListView{
            id: listView
            width: 200
            height: 600
            model: model
        }

        Button{
            text: "Remove"
            onClicked: {
                model.removeEvents(listView.selectedItems().map(index => model.index(index,0)));
            }
        }

        Button{
            text: "Reset"
            onClicked: {
                model.resetModel();
            }
        }

    }

    TestListModel {
        id: model
    }
}
