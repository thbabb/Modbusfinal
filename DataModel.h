#ifndef DATAMODEL_H
#define DATAMODEL_H

#include <QAbstractListModel>
#include <QAbstractItemModel>
#include <QObject>
#include <QList>
#include <QModbusDataUnit>
#include "modbusmanager.h"

class DataModel : public QAbstractListModel
{
    Q_OBJECT
public:

  enum Roles{
      listARole = Qt::UserRole,
      listBRole
            };

    // Constructor and Destructor

    DataModel(QObject *parent = 0);
    ~DataModel();

    // Model Control

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    // Access of class modbusmanager

    modbusmanager* m_modbusmanager = nullptr;
    Q_INVOKABLE void reset();

public slots :

     void getData();

private : 

    QList<QString> m_list;
    QList<QString> m_newlist;    
    int m_nbcall = 0;

};

#endif // DATAMODEL_H



