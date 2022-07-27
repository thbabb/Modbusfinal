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
 // void read_RAM_MA_US();
    QString modbusState(){if(modbusDevice->state()==QModbusDevice::ConnectedState) return "Connected"; else return "Not Connected";};
    QModbusDataUnit RAM_MA_US();
    Q_INVOKABLE void read_RAM_MA_US();
    void readState();
    QList<QString> m_registerList;
    Q_INVOKABLE void rState();

    QModbusDataUnit RAM_US_STATE();
    Q_INVOKABLE int numberofaddress(int numberOfEntries);
    Q_INVOKABLE int startatAddress(int startAddress);
    int m_numberOfEntries=100;
    int m_startAddress = 0;

signals:

    void dataReady();
    void endList();
    void modbusStateChanged(const QString &text);


private:

      int m_sizelist;
      QModbusClient *modbusDevice = nullptr;
      void read_RAM_US_STATE();


};

#endif // MODBUSMANAGER_H
