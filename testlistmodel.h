#ifndef TESTLISTMODEL_H
#define TESTLISTMODEL_H

#include <QAbstractListModel>


class TestListModel: public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        FilenameRole = Qt::UserRole + 1
    };

    explicit TestListModel(QObject *parent = nullptr);

    // TestListModel();

    Q_INVOKABLE void removeEvents(QList<QModelIndex> indexes);
    Q_INVOKABLE void resetModel();

    void initNumbers();

    // QAbstractItemModel interface
    int rowCount(const QModelIndex &parent) const override;
    int columnCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    std::vector<int> m_numbers;
};

#endif // TESTLISTMODEL_H
