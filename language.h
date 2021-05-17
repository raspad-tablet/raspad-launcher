#ifndef LANGUAGE_H
#define LANGUAGE_H

#include <QObject>
#include <QTranslator>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>

class Language : public QObject
{
    Q_OBJECT
public:
    explicit Language(QGuiApplication& app, QQmlApplicationEngine &engine,
                      QObject *parent = nullptr);
    Q_INVOKABLE void setLanguage(int nLanguage);
signals:
    void languageChanged();
public slots:
private:
    QGuiApplication *m_app;
    QQmlApplicationEngine *m_engine;
};

#endif // LANGUAGE_H
