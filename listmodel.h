#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QObject>
#include <QList>

class listmodel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> list READ liste NOTIFY listChanged);
public:


};

#endif // LISTMODEL_H
