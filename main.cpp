#include <QGuiApplication>
#include "DataModel.h"
#include <QQmlApplicationEngine>
#include "modbusmanager.h"
#include <QQuickView>
#include <QQmlContext>




int main(int argc, char *argv[])
{

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);



#endif
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    //  QQmlContext *context = engine.rootContext();
    DataModel monModel;

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("mModel",&monModel);
    engine.rootContext()->setContextProperty("mModbusManager",monModel.m_modbusmanager);
    engine.load(url);

    return app.exec();

}
