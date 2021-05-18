#include "language.h"

Language::Language(QGuiApplication &app, QQmlApplicationEngine& engine,
                   QObject *parent) : QObject(parent)
{
    m_app = &app;
    m_engine = &engine;
}

void Language::setLanguage(int nLanguage)
{
    // qDebug() << "setLanguage:" << nLanguage;
    QTranslator translator;
    if (nLanguage == 1)
    {
        translator.load(":/translations/zh_CN.qm");
    }else{
        translator.load(":/translations/en_US.qm");
    }
    m_app->installTranslator(&translator);
    m_engine->retranslate();
    emit languageChanged();
}
