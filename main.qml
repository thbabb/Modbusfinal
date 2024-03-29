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
            text: "FIRST ACQUISITON"
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
            text: "NEXT ACQUISITION"
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
        anchors.left : showdialog.right
        width:  secondList.width/3
        height: mainwindow.height-secondList.height-rightrectangle.height
        font.pointSize: 10
        //   ToolTip.visible: hovered
        //   ToolTip.text: ("WARNING : CONFIRMED value for Start Address and Nb of Address BEFORE click")
        text : "DATA"
        palette     {
            button: "#E6DFDE"
        }
        onClicked:  {
            mModbusManager.readState();

        }
        Connections {
            target: mModbusManager
            onErrorData: {
                showError.open()
                showErrorConnect.title = msgErrorRead
                textError.text = msgErrorRead
            }
        }
        Connections {
            target: mModbusManager
            onErrorData2: {
                showError.open()
                textError.text = msgErrorRead2 + "Select 10 Address (ERROR for read 100 Address)"
            }
        }
        Connections {
            target: mModbusManager
            onErrorReadConnection: {
                showErrorConnect.open()
                textErrorConnect.text = msgError
            }
        }
    }
  Dialog{
        id : showErrorConnect
       // title : "Error Connect!"
        Column{
            Text {
                id : textErrorConnect

            }
            Button {
                checked: false
                text: qsTr("EXIT")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: showErrorConnect.close()
            }
        }
    }
    Dialog{
        id : showError
        title : "Error !"
        Column{
            Text {
                id : textError
       //         text: qsTr("Select 10 Address (ERROR for read 100 Address)")


            }
            Button {
                checked: false
                text: qsTr("EXIT")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: showError.close()
            }
        }
    }

    Button {
        id : showdialog
        anchors.top: secondList.bottom
        anchors.left : buttonConnect.right
        width:  secondList.width/3
        height: mainwindow.height-secondList.height-rightrectangle.height
        text : "ShowHelp"
        font.pointSize: 10
        onClicked: profilDialog.open()

    }
    Dialog{
        id : profilDialog
        title : "DETAILS CONNECT"
        Column{
            Text {
                id : textInfo
                text: qsTr("- Set your computer local IP to 192.168.1.70 with 255.255.255.0 mask")

            }
            Text{
                id : enterValueInfo
                text : qsTr("- Click on ENTER after write parameters")
            }

            Button {
                checked: false
                text: qsTr("EXIT")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: profilDialog.close()
            }
        }

    }

    Button {
        id : buttonConnect
        anchors.left : firstlist.right
        anchors.top : secondList.bottom
        width:  secondList.width/3
        height: mainwindow.height-secondList.height-rightrectangle.height
        font.pointSize: 10
        text : "CONNECT"
        ToolTip.visible: hovered
        ToolTip.text: ("Click for connect Modbus")
        onClicked:  {
            mModbusManager.connectModbus("192.168.1.10:502")

        }

        palette     {
            button: "#E6DFDE"
        }
        Connections {
            target: mModbusManager
            onErrorConnection: {
                showErrorConnect2.open()
            }
        }
    }

    Dialog{
        id : showErrorConnect2
        title : "Error Connect!"
        Column{
            Text {
                id : textErrorConnect2
                text: qsTr("Connection Error")


            }
            Button {
                checked: false
                text: qsTr("EXIT")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: showErrorConnect2.close()
            }
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
        width: writevalue.width
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
            width: nbrAddress.width
            height: writevalue2.height
            maximumLength: 5
            font.pointSize: 12
            color : parseInt(startAddress.text) > 26000 ? "#FF0000" : "#000000"
            validator: IntValidator{
                bottom:0
                top:26000
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
        text : "ENTER"
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
