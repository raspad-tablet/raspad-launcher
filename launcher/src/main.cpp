#include <QQmlApplicationEngine>
#include <QtGui/QGuiApplication>
#include <QtQml>
#include <QFont>
#include <QObject>
#include <QTranslator>
#include "process.h"
#include "fileinfo.h"

int main(int argc, char **argv) {
    qputenv("QMLSCENE_DEVICE", "softwarecontext");
    qputenv("QT_IM_MODULE", "qtvirtualkeyboard");
    qputenv("QT_PQA_PLATFORM", "xcb");
    qputenv("QT_XCB_GL_INTEGRATION", "xcb_egl");

    QGuiApplication app(argc, argv);

    QFont font;
    font.setFamily("Noto Sans CJK SC");
    app.setFont(font);

    QTranslator translator;
    if (translator.load(QLocale(), QLatin1String(""), QLatin1String(""),
           QLatin1String(":/launcher/translations"))) {
        QCoreApplication::installTranslator(&translator);
    }

    QQmlApplicationEngine engine;

    qmlRegisterType<Process>("Process", 1, 0, "Process");
    qmlRegisterType<FileInfo>("FileInfo", 1, 0, "FileInfo");

    engine.load(QUrl("qrc:///launcher/qml/main.qml"));

    return app.exec();
}
