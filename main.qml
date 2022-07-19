import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.5
import Datamodel 1.0


Window {
    id : mainwindow
    width: 640
    height: 480
    visible: true
   // color : "Grey"

    Datamodel{
        id : myDatamodel

    }

            GridLayout{
                id : firstlist
                    width: mainwindow.width/2
                    height: parent.height
                    anchors.left:parent.left
                    columns:3
                    columnSpacing: 5

                   Repeater {
                        model : monModel
                        height : parent.height
                        Rectangle{
                           width : textvalue.width
                           height : textvalue.height

                         Text {
                             id : textvalue
                             font.bold: true
                             horizontalAlignment: Text.horizontalCenter
                             text: "Adress n°" + index + " = " + listA}

                    }


          }
        }

            GridLayout{
                    width: mainwindow.width/2
                    height: parent.height
                    anchors.left:firstlist.right
                    columns:3
                    columnSpacing: 5
                    Repeater {
                        model : monModel
                        height : parent.height
                        Rectangle{
                           width : textvalue2.width
                           height : textvalue2.height
                           color : listA === listB ? "#008000" : "#FF0000"
                         Text {
                             id : textvalue2
                             font.bold: true
                             horizontalAlignment: Text.horizontalCenter
                             text: "Adress n°" + index + " = " + listB}


          }
        }
    }
}

