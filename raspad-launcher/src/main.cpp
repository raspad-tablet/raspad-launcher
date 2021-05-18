#include <QQmlApplicationEngine>
#include <QtGui/QGuiApplication>
#include <QtQml>
#include <QFont>
#include <QObject>
#include "process.h"
#include "language.h"

int main(int argc, char **argv) {
    qputenv("QMLSCENE_DEVICE", "softwarecontext");
    qputenv("QT_IM_MODULE", "qtvirtualkeyboard");
    qputenv("QT_PQA_PLATFORM", "xcb");
    qputenv("QT_XCB_GL_INTEGRATION", "xcb_egl");

    QGuiApplication app(argc, argv);

    QFont font;
    font.setFamily("Noto Sans CJK SC");
    app.setFont(font);

    QQmlApplicationEngine engine;
    Language language(app, engine);

    qmlRegisterType<Process>("Process", 1, 0, "Process");
    
    engine.rootContext()->setContextProperty("language", &language);
    engine.load(QUrl("qrc:///src/main.qml"));

    return app.exec();
}
