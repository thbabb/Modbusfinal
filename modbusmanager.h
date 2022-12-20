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
// Pouvoir faire un champ afin de se connecteur sur un champ d'adresse IP
//faire de la gestion d'erreur
    explicit modbusmanager(QObject *parent = nullptr);
    Q_INVOKABLE bool connectModbus(QString serverUrl, int responseTime = 1000, int numberOfRetry = 3);
    void onModbusStateCHanged( int state);
    QModbusDataUnit Read_RAM_US1_STATE() const;
    QString modbusState(){if(modbusDevice->state()==QModbusDevice::ConnectedState) return "Connected"; else return "Not Connected";};
    QModbusDataUnit RAM_MA_US();
    void read_RAM_MA_US();
    Q_INVOKABLE void readState();
    QList<QString> registerList;
    QModbusDataUnit RAM_US_STATE();
    Q_INVOKABLE int numberofaddress(int nbNumberOfEntries);
    Q_INVOKABLE int startatAddress(int nbOfStartAddress);
    int numberOfEntries=100;
    int startAddress = 0;

signals:

    void dataReady();
    void endList();
    void modbusStateChanged(const QString &text);
    void errorData(QString msgErrorRead);
    void errorConnection(QString msgError);
     void errorReadConnection(QString msgError);


private:

      QModbusClient *modbusDevice = nullptr;
      //void read_RAM_US_STATE();


};

#endif // MODBUSMANAGER_H
