#include <QObject>

class ProcessEnvironment : public QObject {
    Q_OBJECT

public:
    ProcessEnvironment(QObject *parent = 0) : QObject(parent) {}

    Q_INVOKABLE QString getenv(const QString &varName) {
        return QString::fromLocal8Bit(qgetenv(varName.toLocal8Bit().constData()));
    }

    Q_INVOKABLE bool putenv(const QString &varName, const QString &value) {
       return qputenv(varName.toLocal8Bit().constData(), value.toLocal8Bit());
    }

    Q_INVOKABLE bool unsetenv(const QString &varName) {
        return qunsetenv(varName.toLocal8Bit().constData());
    }
};
