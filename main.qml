import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.5

Window {
    id : mainwindow
    width: 640
    height: 480
    visible: true
   // color : "Grey"

    Rectangle{
                id : rightrectangle
                width : mainwindow.width/2
                height: mainwindow.height/10
                anchors.top : mainwindow.bottom
                color : "#E6DFDE"
                Text {
                    id: nameList
                    anchors.horizontalCenter: rightrectangle.horizontalCenter
                    anchors.verticalCenter: rightrectangle.verticalCenter
                    font.pointSize: 20
                    text: "FIRST VALUE"
                }
    }
                Rectangle{
                            id : leftrectangle
                            width : mainwindow.width/2
                            height: mainwindow.height/10
                            anchors.top : mainwindow.bottom
                            anchors.left : rightrectangle.right
                            color : "#E6DFDE"
                            Text {
                                anchors.horizontalCenter: leftrectangle.horizontalCenter
                                anchors.verticalCenter:leftrectangle.verticalCenter
                                font.pointSize: 20
                                id: nameList2
                                text: "NEXT VALUE"
                            }
                }


            GridLayout{
                id : firstlist
                    width: mainwindow.width/2
                    height: parent.height/1.4
                    anchors.top : rightrectangle.bottom
                    anchors.left:parent.left
                    columns:3
                    columnSpacing: 5

                   Repeater {
                        model : mModel
                        Rectangle{
                           width : firstlist.width/8
                           height : firstlist.height/25

                         Text {
                             id : textvalue
                             font.bold: true
                             font.pointSize: 8
                             horizontalAlignment: Text.horizontalCenter
                             color : listA === listB ? "#000000" : "#FF0000"
                             text: "n° " + index + " = " + listA}

                    }


          }
        }

            GridLayout{
                    id : layoutB
                    width: mainwindow.width/2
                    height: parent.height/1.4
                    anchors.left:firstlist.right
                    anchors.top : leftrectangle.bottom
                    columns:3
                    columnSpacing: 5
                    Repeater {
                        model : mModel
                        width : layoutB.width/8
                        height : layoutB.height/25

                        Rectangle{
                           width : layoutB.width/8
                           height : layoutB.height/25

                         Text {
                             id : textvalue2
                             font.bold: true
                             font.pointSize: 8
                             color : listA === listB ? "#008000" : "#FF0000"
                             horizontalAlignment: Text.horizontalCenter
                             text: "n° " + index + " = " + listB}



          }
        }



    }
            Button {
                id : buttonData
                anchors.top: layoutB.bottom
                anchors.left : buttonConnect.right
                anchors.topMargin: 15
                width: layoutB.width/2
                height: layoutB.height/4.7
                font.pointSize: 18
                text : "DATA"
                onClicked:  {
                   mModbusManager.read_RAM_MA_US()
                   mModbusManager.rState()
                 }
                 }
            Button {
                id : buttonConnect
                anchors.left : firstlist.right
                anchors.top : layoutB.bottom
                width: layoutB.width/2
                height: layoutB.height/4.7
                anchors.topMargin: 15
                font.pointSize: 18
                text : "CONNECT"
                onClicked:  {
                   mModbusManager.connectModbus("192.168.1.10:502");
                 }
                 }
}

