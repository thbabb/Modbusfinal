#include "modbusmanager.h"
#include <QUrl>
#include <QDebug>
#include <QBitArray>
#include <QTimer>
#include <cstring>


modbusmanager::modbusmanager(QObject *parent) : QObject(parent)
{
    modbusDevice = new QModbusTcpClient(this);
    connect(modbusDevice,&QModbusClient::stateChanged,this,&modbusmanager::onModbusStateCHanged);
    for(int i=0;i<100;i++)
    {
        registerList.append("0");
    }
}


bool modbusmanager::connectModbus(QString serverUrl,int responseTime, int numberOfRetry)
{
    if(!modbusDevice)
        return false;
    if(modbusDevice->state() != QModbusDevice::ConnectedState)
    {
        const QUrl url = QUrl::fromUserInput(serverUrl);
        modbusDevice->setConnectionParameter(QModbusDevice::NetworkPortParameter,url.port());
        modbusDevice->setConnectionParameter(QModbusDevice::NetworkAddressParameter,url.host());

        modbusDevice->setTimeout(responseTime);
        modbusDevice->setNumberOfRetries(numberOfRetry);

        if(!modbusDevice->connectDevice())
        {
            qDebug() << "Modbus connect fail"<< modbusDevice->errorString();
            emit errorConnection( modbusDevice->errorString());
        }
        else
        {
            qDebug() << "Modbus Device connected";
        }
    }
    else {
        modbusDevice->disconnectDevice();
        qDebug() << "Modbus device disconnected";
    }
}
void  modbusmanager::readState()
{

    if(!modbusDevice)
        return;
    // read on/off state

    if(auto *reply_RAM_US_STATE= modbusDevice->sendReadRequest(RAM_US_STATE(),1))
    {
        if(!reply_RAM_US_STATE->isFinished())
        {
            connect(reply_RAM_US_STATE,&QModbusReply::finished,this,&modbusmanager::read_RAM_MA_US);
        }
        else
            delete reply_RAM_US_STATE; // broadcast replies return immediately
    }
    else
    {
        qDebug() << "Read error" << modbusDevice->errorString();
        emit errorReadConnection(modbusDevice->errorString());
    }

    return;

}


void modbusmanager::onModbusStateCHanged(int state)
{
    if (state == QModbusDevice::UnconnectedState)
    {
        qDebug() << "Disconnected event";
        emit modbusStateChanged("Disconnected");

    }
    else if (state == QModbusDevice::ConnectedState)
    {
        qDebug() << "Connected event";
        emit modbusStateChanged("Connected");

    }



}
QModbusDataUnit modbusmanager::RAM_US_STATE()
{
    const auto table = static_cast<QModbusDataUnit::RegisterType>(QModbusDataUnit::HoldingRegisters);
    return QModbusDataUnit(table,startAddress,numberOfEntries);
}

int modbusmanager::numberofaddress(int nbNumberOfEntries)
{
    numberOfEntries = nbNumberOfEntries;
    return numberOfEntries;
}

int modbusmanager::startatAddress(int nbOfStartAddress)
{
    startAddress = nbOfStartAddress;
    return startAddress;
}

void modbusmanager::read_RAM_MA_US()
{

    auto reply_RAM_US1_STATE = qobject_cast<QModbusReply *>(sender());
    if(!reply_RAM_US1_STATE)
    {
        return;
    }
    if(reply_RAM_US1_STATE->error() == QModbusDevice::NoError)
    {
        qDebug() << "reply_RAM_US1_STATE -> OK";
        const QModbusDataUnit unit_RAM_US1_STATE = reply_RAM_US1_STATE->result();

        for(int i = 0, total = int(unit_RAM_US1_STATE.valueCount()); i<total; i++)
        {
            /*   const QString entry = tr("Address: %1, Value: %2").arg(unit_RAM_US1_STATE.startAddress()+i)
                    .arg(QString::number(unit_RAM_US1_STATE.value(i),
                                         unit_RAM_US1_STATE.registerType() <= QModbusDataUnit::Coils ? 10 :16));*/

            registerList.replace(i,QString::number(unit_RAM_US1_STATE.value(i)));

        }


        emit endList();

    }
    else if (reply_RAM_US1_STATE->error() == QModbusDevice::ProtocolError)
    {
        qDebug() << "Read response error RAM_US1_STATE : " << reply_RAM_US1_STATE->errorString() << reply_RAM_US1_STATE->rawResult().exceptionCode();
        if(reply_RAM_US1_STATE->rawResult().exceptionCode() == 2)
            emit errorData(reply_RAM_US1_STATE->errorString() + reply_RAM_US1_STATE->rawResult().exceptionCode() + " --- " + "END OF ADDRESS");
        else if (reply_RAM_US1_STATE->rawResult().exceptionCode() == 2)
            emit errorData(reply_RAM_US1_STATE->errorString() + reply_RAM_US1_STATE->rawResult().exceptionCode() + " --- " + "Select 10 Address (ERROR for read 100 Address)");
        emit errorData(reply_RAM_US1_STATE->errorString() + reply_RAM_US1_STATE->rawResult().exceptionCode());
    }
    else
    {
        qDebug() << "Read response error RAM_US1_STATE : " << reply_RAM_US1_STATE->errorString();
        emit errorData(reply_RAM_US1_STATE->errorString());
    }
    reply_RAM_US1_STATE->deleteLater();
}








