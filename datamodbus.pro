QT += quick
QT += serialbus
QT += virtualkeyboard
QT += qml quick
CONFIG += c++11 link_pkgconfig static


# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0
static {
    QT += svg
    QTPLUGIN += qtvirtualkeyboardplugin
}
SOURCES += \
        DataModel.cpp \
        main.cpp \
        modbusmanager.cpp

RESOURCES += qml.qrc

QT_VIRTUALKEYBOARD_HUNSPELL_DATA_PATH=qtbase/qtvirtualkeyboard/hunspell
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    DataModel.h \
    modbusmanager.h
