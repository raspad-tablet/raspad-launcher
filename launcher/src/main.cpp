#include <QQmlApplicationEngine>
#include <QtGui/QGuiApplication>
#include <QtQml>
#include <QFont>
#include <QObject>
#include <QTranslator>
#include "process.h"
#include "fileinfo.h"
#include "processenvironment.h"

int main(int argc, char **argv) {
    qputenv("QMLSCENE_DEVICE", "softwarecontext");
    qputenv("QT_IM_MODULE", "qtvirtualkeyboard");
    qputenv("QT_PQA_PLATFORM", "xcb");
    qputenv("QT_XCB_GL_INTEGRATION", "xcb_egl");
    // Enable file:// access in XMLHttpRequest in main.qml
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");

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
    qmlRegisterType<ProcessEnvironment>("ProcessEnvironment", 1, 0, "ProcessEnvironment");

    engine.load(QUrl("qrc:///launcher/qml/main.qml"));

    return app.exec();
}
