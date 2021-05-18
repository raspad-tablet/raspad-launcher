TEMPLATE = app
TARGET = raspad-launcher
QT += qml core quick network 

SOURCES += \
    raspad-launcher/src/main.cpp \
    raspad-launcher/src/language.cpp

RESOURCES += raspad-launcher.qrc

CONFIG += localize_deployment
TRANSLATIONS += \
    raspad-launcher/translations/en_US.ts \
    raspad-launcher/translations/zh_CN.ts \
    raspad-launcher/translations/base.ts

HEADERS += \
    raspad-launcher/src/process.h \
    raspad-launcher/src/language.h

DISTFILES += \
    raspad-launcher/images/Accessories.png \
    raspad-launcher/images/center.png \
    raspad-launcher/images/Games.png \
    raspad-launcher/images/Help.png \
    raspad-launcher/images/Home.png \
    raspad-launcher/images/Internet.png \
    raspad-launcher/images/logo.png \
    raspad-launcher/images/Office.png \
    raspad-launcher/images/Preferences.png \
    raspad-launcher/images/Programming.png \
    raspad-launcher/images/Run.png \
    raspad-launcher/images/shutdown.png \
    raspad-launcher/images/triangle.png \
    raspad-launcher/qml/main.qml\
    raspad-launcher/qml/run.qml

SUBDIRS += \
    raspad-launcher.pro

target.path = /home/pi/raspad
INSTALLS += target
