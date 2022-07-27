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
    //Allocate memory for m_modbusmanager
    m_modbusmanager = new modbusmanager(this);

    //Signal : data are receive on the class modbusmanager then we can retrieve data with the function getData

    connect(m_modbusmanager,&modbusmanager::endList,this,&DataModel::getData);

    // Init of the list
    for(int i = 0;i<100;i++)
    {
        m_list.append("0");
        m_newlist.append("0");
    }

}

void DataModel::getData()
{

    qDebug() << "signal dataReady OK";

    // Number of call

    m_nbcall++;
    //notify views and proxy models that a line will be inserted

    qDebug() << "Call n° " << m_nbcall;

    if(m_nbcall == 1)
    {

        for(int i =0;i<m_modbusmanager->m_numberOfEntries;i++)
        {

            m_list[i] = m_modbusmanager->m_registerList[i];

        }

    }
    else
    {

        for(int i =0;i<m_modbusmanager->m_numberOfEntries;i++)
        {
            m_newlist[i] = m_modbusmanager->m_registerList[i];
        }

    }

    //finish insertion, notify views/models

    // Update of the list and call model to say a value changed and retrieve the new value for display the new list on the qml

    QModelIndex topLeft = createIndex(0,0);
    QModelIndex bottomRight = createIndex( rowCount(),0);
    emit dataChanged( topLeft, bottomRight );

}
DataModel::~DataModel()
{
    // deletion of m_modbusmanager to avoid a memory leak

    delete m_modbusmanager;
}


int DataModel::rowCount(const QModelIndex& parent) const
{

    //Return the number of rows of the list

    if (parent.isValid())
        return 0;
else
    return m_list.size() ;

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

/*bool DataModel::insertRows(int row, int count, const QModelIndex &parent)
{
    beginInsertRows(parent, row, row + count - 1);
    for(int i=m_list.size();i< m_modbusmanager->m_numberOfEntries;i++)
     {

        m_list.append("0");
        m_newlist.append("0");
     }
     endInsertRows();
     return true;

}*/


void DataModel::reset()
{

    if (m_list.size()>m_modbusmanager->m_numberOfEntries)
    {
             beginRemoveRows(QModelIndex(), m_modbusmanager->m_numberOfEntries, 100);
             for(int i=m_modbusmanager->m_numberOfEntries;i<100;i++)
             {
                m_list.removeAt(m_modbusmanager->m_numberOfEntries);
                m_newlist.removeAt(m_modbusmanager->m_numberOfEntries);
             }
             endRemoveRows();

    }
    if (m_list.size()<m_modbusmanager->m_numberOfEntries)
    {

        qDebug() << m_list.size();
        qDebug() << m_modbusmanager->m_numberOfEntries;
       // this->insertRows(10,10,QModelIndex());

             beginInsertRows(QModelIndex(),m_list.size(),m_modbusmanager->m_numberOfEntries-1);
             for(int i=m_list.size();i< m_modbusmanager->m_numberOfEntries;i++)
              {

                m_list.append("0");
                m_newlist.append("0");
              }
            qDebug() << m_list;
             endInsertRows();

    }

}





