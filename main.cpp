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

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    DataModel datamodel;
    engine.rootContext()->setContextProperty("monModel",&datamodel);
    qmlRegisterType<DataModel>("Datamodel",1,0,"Datamodel");
    const QUrl url(QStringLiteral("qrc:/main.qml"));
   // QQmlContext* ctx = engine.rootContext();
   // ctx->setContextProperty("Vchanged", &monModel);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
