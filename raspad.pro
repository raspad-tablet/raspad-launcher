TEMPLATE = app
TARGET = raspad
QT += qml core quick network 

SOURCES += \
    main.cpp \
    language.cpp

RESOURCES += resource.qrc

CONFIG += localize_deployment
TRANSLATIONS += translations/en_US.ts \
            translations/zh_CN.ts \
            translations/base.ts

HEADERS += \
    process.h \
    language.h

DISTFILES += \
    images/Accessories.png \
    images/center.png \
    images/Games.png \
    images/Help.png \
    images/Home.png \
    images/Internet.png \
    images/logo.png \
    images/Office.png \
    images/Preferences.png \
    images/Programming.png \
    images/Run.png \
    images/shutdown.png \
    images/triangle.png \
    register/icons/female.png \
    register/icons/male.png \
    src/main.qml\
    src/run.qml

SUBDIRS += \
    raspad.pro

target.path = /home/pi/raspad
INSTALLS += target
