#include <QProcess>
#include <QVariant>
#include <QDir>

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

    Q_INVOKABLE bool startDetached(qint64 *pid = nullptr) {
        return QProcess::startDetached(pid);
    }

    Q_INVOKABLE void setProgram(const QString &program) {
        QProcess::setProgram(program);
    }

    Q_INVOKABLE void setWorkingDirectory(const QString &dir) {
        QProcess::setWorkingDirectory(dir);
    }

    Q_INVOKABLE void setWorkingDirectoryHome() {
        QProcess::setWorkingDirectory(QDir::homePath());
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

    Q_INVOKABLE void setStandardFilesToNull() {
        QString nullDev = nullDevice();
        setStandardInputFile(nullDev);
        setStandardOutputFile(nullDev);
        setStandardErrorFile(nullDev);
    }
};
