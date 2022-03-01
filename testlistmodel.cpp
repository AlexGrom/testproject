#include "testlistmodel.h"


TestListModel::TestListModel(QObject *parent): QAbstractListModel(parent)
{
    initNumbers();
}

void TestListModel::initNumbers()
{
    auto count = 1000;

    for (int i = 0; i < count; i++)
    {
        m_numbers.push_back(i);
    }
}


int TestListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return m_numbers.size();
}

int TestListModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return 1;
}

QVariant TestListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() > rowCount(index)) {
        return {};
    }

    switch (role) {
    case Qt::DisplayRole:
        return QVariant::fromValue(m_numbers[index.row()]);
    default:
        return {};

    }
}

QHash<int, QByteArray> TestListModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[Qt::DisplayRole] = "value";
    //  roles[Roles::DisplayRole] = "filename";

    return roles;
}


void TestListModel::resetModel()
{
    beginResetModel();

    initNumbers();

    endResetModel();
}


void TestListModel::removeEvents(QList<QModelIndex> indexes)
{
    qDebug()<<"indexes="<<indexes;
    std::sort(indexes.begin(), indexes.end(), [](QModelIndex a, QModelIndex b) {
        return a.row() > b.row();
    });

    for (auto &index : indexes) {
        const auto row = index.row();

        beginRemoveRows(this->index(row, 0).parent(), row, row);

        m_numbers.erase(m_numbers.begin() + row);
        qDebug()<<"Row="<<index.column();

        endRemoveRows();
    }

    //updateOrders();

}

//void TestListModel::updateOrders()
//{
//    // Order should be started from "1"
//    for (int idx = 0; idx < m_numbers.size(); ++idx) {
//        m_numbers[idx].setOrder(idx + 1);
//    }
//}
