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
         m_registerList.append("0");
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
            qDebug() << "Modbus connect fail"<< modbusDevice->errorString();
        else
        {
            qDebug() << "Modbus Device connected";

        }
    }
    else {
        modbusDevice->disconnectDevice();
        qDebug() << "Modbus device disconnected";
        return false;
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
    }
    return;

}

void modbusmanager::rState()
{
  if(modbusDevice->state() == QModbusDevice::ConnectedState)
  {
    readState();
  }
    else
  return;
}

bool modbusmanager::openconnect()
{
    if(modbusDevice->state() == QModbusDevice::ConnectedState)
    {
      return true;
    }
      else
    {
    return false;
    }
}

QModbusDataUnit modbusmanager::RAM_MA_US()
    {
        const auto table = static_cast<QModbusDataUnit::RegisterType>(QModbusDataUnit::HoldingRegisters);

        int startAddress = 83; // dec ? hex ?
        quint16 numberOfEntries = 2; // 16 bits ?
        return QModbusDataUnit(table,startAddress,numberOfEntries);

    }
void modbusmanager::onModbusStateCHanged(int state)
{
    if (state == QModbusDevice::UnconnectedState)
    {
        qDebug() << "Disconnected event";


    }
    else if (state == QModbusDevice::ConnectedState)
    {
        qDebug() << "Connected event";


    }

    emit modbusStateChanged();

}
QModbusDataUnit modbusmanager::RAM_US_STATE()
{
    const auto table = static_cast<QModbusDataUnit::RegisterType>(QModbusDataUnit::HoldingRegisters);
    int startAddress = 0; // dec ? hex ?
    quint16 numberOfEntries = 84; // 16 bits ?
    return QModbusDataUnit(table,startAddress,numberOfEntries);
}

QModbusDataUnit modbusmanager::Read_RAM_US1_STATE() const
{
    const auto RAM_US1_STATE = static_cast<QModbusDataUnit::RegisterType>(QModbusDataUnit::HoldingRegisters);

    int startAddress = 84; // dec
    quint16 numberOfEntries = 1; // 16 bits ?
    return QModbusDataUnit(RAM_US1_STATE,startAddress,numberOfEntries);
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
            const QString entry = tr("Address: %1, Value: %2").arg(unit_RAM_US1_STATE.startAddress()+i)
                    .arg(QString::number(unit_RAM_US1_STATE.value(i),
                                         unit_RAM_US1_STATE.registerType() <= QModbusDataUnit::Coils ? 10 :16));

                   m_registerList.replace(i,QString::number(unit_RAM_US1_STATE.value(i)));

            }

        emit endList();
    }
    else if (reply_RAM_US1_STATE->error() == QModbusDevice::ProtocolError)
    {
        qDebug() << "Read response error RAM_US1_STATE : " << reply_RAM_US1_STATE->errorString() << reply_RAM_US1_STATE->rawResult().exceptionCode();
    }
    else
        qDebug() << "Read response error RAM_US1_STATE : " << reply_RAM_US1_STATE->errorString();

    reply_RAM_US1_STATE->deleteLater();
}








