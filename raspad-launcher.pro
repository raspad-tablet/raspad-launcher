TEMPLATE = app
TARGET = raspad-launcher
QT += qml core quick network 

SOURCES += \
    launcher/src/main.cpp

RESOURCES += raspad-launcher.qrc

CONFIG += localize_deployment
TRANSLATIONS += \
    launcher/translations/en_US.ts \
    launcher/translations/zh_CN.ts \
    launcher/translations/base.ts

HEADERS += \
    launcher/src/process.h \
    launcher/src/fileinfo.h

DISTFILES += \
    launcher/images/Accessories.png \
    launcher/images/center.png \
    launcher/images/Games.png \
    launcher/images/Help.png \
    launcher/images/Home.png \
    launcher/images/Internet.png \
    launcher/images/logo.png \
    launcher/images/Office.png \
    launcher/images/Preferences.png \
    launcher/images/Programming.png \
    launcher/images/Run.png \
    launcher/images/shutdown.png \
    launcher/images/triangle.png \
    launcher/qml/main.qml\
    launcher/qml/run.qml \
    launcher/qml/execvalueparser.js

SUBDIRS += \
    raspad-launcher.pro

target.path = /home/pi/raspad
INSTALLS += target
