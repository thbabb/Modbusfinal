import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.1


Window {
    id : mainwindow
    width: 640
    height: 480
    visible: true

    Rectangle{
                id : leftrectangle
                width : mainwindow.width-rightrectangle.width
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

    Grid{
                id : firstlist
                width: mainwindow.width/2
                height: mainwindow.height/1.4
                anchors.top : rightrectangle.bottom
                anchors.left: mainwindow.left
                columns:4

                   Repeater {
                              model : mModel

                              Rectangle{
                                        id : listrectangle
                                        width : firstlist.width/parent.columns
                                        height : firstlist.height/(100/parent.columns)
                                        border.color: "black"

                                        Text {
                                                 id : textvalue
                                                 font.bold: true
                                                 font.pointSize: 8
                                                 horizontalAlignment: Text.horizontalCenter
                                                 anchors.horizontalCenter: listrectangle.horizontalCenter
                                                 anchors.verticalCenter:  listrectangle.verticalCenter
                                                 color : listA === listB ? "#000000" : "#FF0000"
                                                 text: "n° " + (index+Number(startAddress.text)) + " = " + listA}

                                       }
                            }
              }

     Grid{
                 id : secondList
                 width: mainwindow.width/2
                 height: mainwindow.height/1.4
                 anchors.left: firstlist.right
                 anchors.top : rightrectangle.bottom
                 columns:4

                    Repeater {
                               model : mModel

                               Rectangle{
                                          id : listrectangle2
                                          width : secondList.width/parent.columns
                                          height : secondList.height/(100/parent.columns)
                                          border.color: "black"

                                          Text {
                                                 id : textvalue2
                                                 font.bold: true
                                                 font.pointSize: 8
                                                 anchors.horizontalCenter: listrectangle2.horizontalCenter
                                                 anchors.verticalCenter:  listrectangle2.verticalCenter
                                                 color : listA === listB ? "#008000" : "#FF0000"
                                                 horizontalAlignment: Text.horizontalCenter
                                                 text: "n° " + (index+Number(startAddress.text)) + " = " + listB}

                                        }
                             }
                }

     Button {
                id : buttonData
                anchors.top: secondList.bottom
                anchors.left : buttonConnect.right
                width:  secondList.width/2
                height: mainwindow.height-secondList.height-rightrectangle.height
                font.pointSize: 18
                ToolTip.visible: hovered
                ToolTip.text: ("WARNING : CONFIRMED value for Start Address and Nb of Address BEFORE click")
                text : "DATA"
                palette     {
                             button: "#E6DFDE"
                            }
                onClicked:  {
                             mModbusManager.rState();
                            }
            }

     Button {
                id : buttonConnect
                anchors.left : firstlist.right
                anchors.top : secondList.bottom
                width:  secondList.width/2
                height: mainwindow.height-secondList.height-rightrectangle.height
                font.pointSize: 18
                text : "CONNECT"
                ToolTip.visible: hovered
                ToolTip.text: ("Click for connect Modbus")
                onClicked:  {
                             
                              mModbusManager.connectModbus("192.168.1.10:502");
                              mModbusManager.connectModbus("192.168.1.12:502");
                            }
                palette     {
                              button: "#E6DFDE"
                            }
            }

     Rectangle{
                id : infoconnect
                anchors.top: firstlist.bottom
                anchors.left : firstlist.left
                width: secondList.width/2
                height: mainwindow.height-firstlist.height-leftrectangle.height
                color : "#E6DFDE"

                Text {
                        id: testconnect
                        anchors.horizontalCenter: infoconnect.horizontalCenter
                        anchors.verticalCenter: infoconnect.verticalCenter
                        font.pointSize: 15
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
         width: textnbaddress.width
         height: secondList.height/16
         color : "#E6DFDE"
                Text {
                         id: textnbaddress
                         font.pointSize: 7
                         font.bold: true
                         anchors.horizontalCenter: writevalue.horizontalCenter
                         anchors.verticalCenter:  writevalue.verticalCenter
                         text: ("Nb of Address = ")
                     }

                TextInput{
                    id : nbrAddress
                    anchors.left: textnbaddress.right
                    width: buttonsetadress.width - textnbaddress.width
                    height: writevalue.height
                    font.pointSize: 12
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    color : parseInt(nbrAddress.text) > 100 || parseInt(nbrAddress.text) === 0 ? "#FF0000" : "#000000"
                    validator: IntValidator {
                        bottom: 1
                        top : 100
                    }
                    maximumLength: 3                
                    onEditingFinished:  {
                        mModbusManager.numberofaddress(Number(nbrAddress.text));
                    }
                         }
     }
     Rectangle {
         id: writevalue2
         anchors.top: writevalue.bottom
         anchors.left : infoconnect.right
         width: textstartadress.width
         height: secondList.height/16
         color : "#E6DFDE"
                 Text {
                     id: textstartadress
                     font.pointSize: 7
                     font.bold: true
                     anchors.horizontalCenter: writevalue2.horizontalCenter
                     anchors.verticalCenter:  writevalue2.verticalCenter
                     text: ("Start Address = ")
                 }



                TextInput{
                    id : startAddress
                    anchors.left: writevalue2.right
                    width: buttonsetadress.width - writevalue2.width
                    height: writevalue2.height
                    maximumLength: 4
                    font.pointSize: 12
                    validator: IntValidator{
                        bottom:0
                        top:9999
                    }

                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    onEditingFinished:  {
                        mModbusManager.startatAddress(Number(startAddress.text))
                    }
                         }
     }
     Button {
                id : buttonsetadress
                anchors.left : infoconnect.right
                anchors.top : writevalue2.bottom
                width:  secondList.width/2
                height: mainwindow.height-firstlist.height-rightrectangle.height-startAddress.height-nbrAddress.height
                font.pointSize: 15
                text : "CONFIRMED"
                ToolTip.visible: hovered
                ToolTip.text: ("Click for confirm value")
                onClicked:  {
                              mModel.reset();
                            }
                palette     {
                              button: "#E6DFDE"
                            }
            }


        }

