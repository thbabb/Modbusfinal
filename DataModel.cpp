#include "DataModel.h"
#include "QList"
#include "QDebug"
#include <QUrl>
#include <QBitArray>
#include <QTimer>
#include <cstring>





DataModel::DataModel(QObject *parent) : QAbstractListModel(parent)
{
    m_sizelist = 84;
    m_modbusmanager = new modbusmanager();
    m_modbusmanager->connectModbus("192.168.1.10:502");
    connect(m_modbusmanager,&modbusmanager::dataReady,this,&DataModel::getData);
    for(int i = 0;i<m_sizelist;i++)
    {
        m_list.append("0");
        m_newlist.append("0");
    }
}

void DataModel::getData()
{
    m_ready ++;
    if(m_ready == 1)
    {
        for(int i =0;i<m_modbusmanager->m_registerList.size();i++)
        {
            m_list.append(m_modbusmanager->m_registerList[i]);
        }
    }
    else
    {
        for(int i =0;i<m_modbusmanager->m_registerList.size();i++)
        {
            m_newlist.append(m_modbusmanager->m_registerList[i]);
        }

    }
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







