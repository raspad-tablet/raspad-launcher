#include <QProcess>
#include <QVariant>

class Process : public QProcess {
    Q_OBJECT

public:
    Process(QObject *parent = 0) : QProcess(parent) { }

    Q_INVOKABLE void start(const QString &program, const QVariantList &arguments) {
        QStringList args;

        // convert QVariantList from QML to QStringList for QProcess 

        for (int i = 0; i < arguments.length(); i++)
            args << arguments[i].toString();

        QProcess::start(program, args);
    }

    Q_INVOKABLE void startDetached(qint64 *pid = nullptr) {
        QProcess::startDetached(pid);
    }

    Q_INVOKABLE void setProgram(const QString &program) {
        QProcess::setProgram(program);
    }

    Q_INVOKABLE void setArguments(const QVariantList &arguments) {
        QStringList args;

        // convert QVariantList from QML to QStringList for QProcess 
        for (int i = 0; i < arguments.length(); i++)
            args << arguments[i].toString();

        QProcess::setArguments(args);
    }

    Q_INVOKABLE QVariantList arguments() {
        QStringList args = QProcess::arguments();
        QVariantList arguments;
        // convert QVariantList from QML to QStringList for QProcess 
        for (int i = 0; i < args.length(); i++)
            arguments << args[i];

        return arguments;
    }

    Q_INVOKABLE QByteArray readAll() {
        return QProcess::readAll();
    }

    Q_INVOKABLE bool waitForFinished(int msecs) {
        return QProcess::waitForFinished(msecs);
    }

    Q_INVOKABLE QProcess::ProcessState state() {
        return QProcess::state();
    }
};