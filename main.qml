import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.5


Window {
    id : mainwindow
    width: 640
    height: 480
    visible: true

    Rectangle{
                id : leftrectangle
                width : mainwindow.width/2
                height: mainwindow.height/10
                anchors.top : mainwindow.bottom
                border.color: "black"
                color : "#E6DFDE"
                Text {
                    anchors.horizontalCenter: leftrectangle.horizontalCenter
                    anchors.verticalCenter: leftrectangle.verticalCenter
                    font.pointSize: 20
                    text: "FIRST VALUE"
                     }
             }

    Rectangle{
                id : rightrectangle
                width : mainwindow.width/2
                height: mainwindow.height/10
                anchors.top : mainwindow.bottom
                anchors.left : leftrectangle.right
                border.color: "black"
                color : "#E6DFDE"
                Text {
                    anchors.horizontalCenter: rightrectangle.horizontalCenter
                    anchors.verticalCenter:   rightrectangle.verticalCenter
                    font.pointSize: 20
                    text: "NEXT VALUE"
                      }
              }

    GridLayout{
                id : firstlist
                width: mainwindow.width/2
                height: parent.height/1.4
                anchors.top : rightrectangle.bottom
                anchors.left: parent.left
                columns:3

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
                                                 text: "n° " + (index+parseInt(startAddress.text)) + " = " + listA}

                                       }
                            }
              }

     GridLayout{
                 id : secondList
                 width: mainwindow.width/2
                 height: parent.height/1.4
                 anchors.left: firstlist.right
                 anchors.top : rightrectangle.bottom
                 columns:3

                    Repeater {
                               model : mModel

                               Rectangle{
                                          width : secondList.width/8
                                          height : secondList.height/2

                                          Text {
                                                 id : textvalue2
                                                 font.bold: true
                                                 font.pointSize: 8
                                                 color : listA === listB ? "#008000" : "#FF0000"
                                                 horizontalAlignment: Text.horizontalCenter
                                                 text: "n° " + (index+parseInt(startAddress.text)) + " = " + listB}

                                        }
                             }
                }

     Button {
                id : buttonData
                anchors.top: secondList.bottom
                anchors.left : buttonConnect.right
                anchors.topMargin: 15
                width:  secondList.width/2
                height: secondList.height/4
                font.pointSize: 18
                ToolTip.visible: hovered
                ToolTip.text: ("Click for receive data")
                text : "DATA"
                palette     {
                             button: "#E6DFDE"
                            }
                onClicked:  {
                             mModbusManager.read_RAM_MA_US();
                             mModbusManager.rState();

                            }
            }

     Button {
                id : buttonConnect
                anchors.left : firstlist.right
                anchors.top : secondList.bottom
                width:  secondList.width/2
                height: secondList.height/4
                anchors.topMargin: 15
                font.pointSize: 18
                text : "CONNECT"
                ToolTip.visible: hovered
                ToolTip.text: ("Click for connect Modbus")
                onClicked:  {
                              mModbusManager.connectModbus("192.168.1.10:502");
                            }
                palette     {
                              button: "#E6DFDE"
                            }
            }

     Rectangle{
                id : infoconnect
                anchors.top: firstlist.bottom
                anchors.left : firstlist.left
                anchors.topMargin: 15
                width: secondList.width/2
                height: secondList.height/4
                color : "#E6DFDE"

                Text {
                        id: testconnect
                        anchors.horizontalCenter: infoconnect.horizontalCenter
                        anchors.verticalCenter: infoconnect.verticalCenter
                        font.pointSize: 10
                        text:  "Disconnected"
                        color: "red"

                        Connections{
                                    target: mModbusManager
                                    onModbusStateChanged : {
                                                            testconnect.text = text
                                                            if (testconnect.text === "Disconnected")
                                                            {
                                                                 testconnect.color = "red"
                                                            }
                                                            else
                                                            {
                                                                 testconnect.color = "green"
                                                            }
                                                            }
                                   }
                    }

              }
     Rectangle {
         id: writevalue
         anchors.top: firstlist.bottom
         anchors.left : infoconnect.right
         anchors.topMargin: 15
         width: secondList.width/2
         height: secondList.height/16
         color : "#E6DFDE"

        TextInput{
            id : nbrAddress
            width: writevalue.width
            height: writevalue.height
            //  wrapMode: TextInput.Wrap
            validator: IntValidator {
                bottom: 1
                top : 100
            }
            maximumLength: 3
            anchors.horizontalCenter:  writevalue.horizontalCenter
            onAccepted: {
                mModbusManager.addressManag(parseInt(nbrAddress.text))
            }
        }
     }
     Rectangle {
         id: writevalue2
         anchors.top: writevalue.bottom
         anchors.left : infoconnect.right
         width: secondList.width/2
         height: secondList.height/16
         color : "#E6DFDE"

        TextInput{
            id : startAddress
            width: writevalue2.width
            height: writevalue2.height
          //  wrapMode: TextInput.Wrap
            maximumLength: 3
            anchors.horizontalCenter:  writevalue2.horizontalCenter
            onAccepted: {
                mModbusManager.startAddressManag(parseInt(startAddress.text))
            }
        }
     }
     Button {
                id : buttonsetadress
                anchors.left : infoconnect.right
                anchors.top : writevalue2.bottom
                width:  secondList.width/2
                height: secondList.height/10
                font.pointSize: 18
                text : "Enter"
                ToolTip.visible: hovered
                ToolTip.text: ("Click for connect Modbus")
                onClicked:  {
                              mModel.reset();
                            }
                palette     {
                              button: "#E6DFDE"
                            }
            }


        }

