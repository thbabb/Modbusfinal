#include "DataModel.h"
#include "QList"
#include "QDebug"
#include <QUrl>
#include <QBitArray>
#include <QTimer>
#include <cstring>
#include <QThread>


DataModel::DataModel(QObject *parent) : QAbstractListModel(parent)
{
    //Number of indexes to print on the QML

    m_sizelist = 84;

    //Allocate memory for m_modbusmanager

    m_modbusmanager = new modbusmanager(this);

    //Signal : data are receive on the class modbusmanager then we can retrieve data with the function getData

    connect(m_modbusmanager,&modbusmanager::endList,this,&DataModel::getData);

   // m_modbusmanager->connectModbus("192.168.1.10:502");

    for(int i = 0;i<m_sizelist;i++)
    {
        m_list.append("0");
        m_newlist.append("0");
    }
}

void DataModel::getData()
{
    qDebug() << "signal dataReady OK";
    m_nbcall++;
    qDebug() << "Call n° " << m_nbcall;
    if(m_nbcall == 1)
    {

        for(int i =0;i<m_sizelist;i++)
        {

            m_list[i] = m_modbusmanager->m_registerList[i];
          //  qDebug() << "La listA est : " << m_list[i];

        }
    }

    else
    {
        for(int i =0;i<m_sizelist;i++)
        {

            m_newlist[i] = m_modbusmanager->m_registerList[i];
           // qDebug() << "La listB est : " << m_newlist[i];

        }

    }
    QModelIndex topLeft = createIndex(0,0);
    QModelIndex bottomRight = createIndex( rowCount(),0);
    emit dataChanged( topLeft, bottomRight );


}
DataModel::~DataModel()
{
    delete m_modbusmanager;
}


int DataModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_list.size();

}


QVariant DataModel::data(const QModelIndex& index, int role) const
{
  if (role == listARole)
  {
          return  m_list.at(index.row());
  }
  else if (role == listBRole)
  {
          return  m_newlist.at(index.row());
  }
  return QVariant();
}

QHash<int, QByteArray> DataModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names.insert(listARole, "listA");
    names.insert(listBRole, "listB");
    return names;
}









