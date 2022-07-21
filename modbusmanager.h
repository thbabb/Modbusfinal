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
    Q_INVOKABLE bool connectModbus(QString serverUrl, int responseTime = 1000, int numberOfRetry = 3);
    void onModbusStateCHanged( int state);
    QString RAM_US1_STATE;
    QModbusDataUnit Read_RAM_US1_STATE() const;
 //   void read_RAM_MA_US();
    QString modbusState(){if(modbusDevice->state()==QModbusDevice::ConnectedState) return "Connected"; else return "Not Connected";};
    QModbusDataUnit RAM_MA_US();
    Q_INVOKABLE void read_RAM_MA_US();
    void readState();
    //Q_INVOKABLE void receiveData();
    QList<QString> m_registerList;
    Q_INVOKABLE void rState();
    Q_INVOKABLE void openconnect();

signals:

    void dataReady();
    void endList();
    void modbusStateChanged();


private:

      QModbusClient *modbusDevice = nullptr;
      void read_RAM_US_STATE();
      QModbusDataUnit RAM_US_STATE();
};

#endif // MODBUSMANAGER_H
