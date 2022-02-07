#include <QFileInfo>

// class that is used as qml type with one (static) method.

class FileInfo : public QObject {
    Q_OBJECT

public:
    // If file is not an absolute path, look for file in $PATH.
    // file must be an executable and must not have a relative path.
    // Returns true if found, false otherwise.
    Q_INVOKABLE bool exexcutableFileExists(const QString &file) {
        char fileSeparator = '/';

        if (file.isEmpty()) {
            return false;
        }
        QFileInfo finfo;
        if (file[0] == fileSeparator) {
            // absolute path.
            finfo.setFile(file);
            return finfo.exists() && finfo.isFile() && finfo.isExecutable();
        }
        else if (file.indexOf(QChar(fileSeparator)) == -1) {
            // no relative path.
            QString envPath = QString::fromLocal8Bit(qgetenv("PATH"));
            QStringList paths;
            if (!envPath.isEmpty()) {
                paths = envPath.split(QChar(':'));
            }
            foreach (QString path, paths) {
                if (path.isEmpty()) {
                    finfo.setFile(file);
                }
                else {
                    finfo.setFile(path + fileSeparator + file);
                }
                if (finfo.exists() && finfo.isFile() && finfo.isExecutable()) {
                    return true;
                }
            }
        }
        return false;
    }
};
