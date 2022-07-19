#ifndef MODBUSMANAGER_H
#define MODBUSMANAGER_H

#include <QObject>
#include <QModbusClient>
#include <QModbusDataUnit>
#include <QModbusReply>
#include <QModbusRtuSerialMaster>
#include <QModbusTcpClient>
#include <QtDebug>
#include <QTimer>
#include <QList>


class modbusmanager : public QObject
{
    Q_OBJECT

public:

    explicit modbusmanager(QObject *parent = nullptr);
    bool connectModbus(QString serverUrl, int responseTime = 1000, int numberOfRetry = 3);
    void onModbusStateCHanged( int state);
    QString RAM_US1_STATE;
    QModbusDataUnit Read_RAM_US1_STATE() const;
    QString modbusState(){if(modbusDevice->state()==QModbusDevice::ConnectedState) return "Connected"; else return "Not Connected";};
    QModbusDataUnit RAM_MA_US();
    void readState();
    Q_INVOKABLE void receiveData();
    QList<QString> m_registerList;

signals:

    void modbusStateChanged();
    void dataReady();
    void connected();


private:

      QModbusClient *modbusDevice = nullptr;
      void read_RAM_US_STATE();
      QModbusDataUnit RAM_US_STATE();
};

#endif // MODBUSMANAGER_H
