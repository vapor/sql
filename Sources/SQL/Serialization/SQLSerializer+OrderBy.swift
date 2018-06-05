extension SQLSerializer {
    /// See `SQLSerializer`.
    public func serialize(orderBys: [SQLQuery.DML.OrderBy]) -> String {
        var statement: [String] = []

        statement.append("ORDER BY")
        statement.append(orderBys.map(serialize).joined(separator: ", "))

        return statement.joined(separator: " ")
    }

    /// See `SQLSerializer`.
    public func serialize(orderBy: SQLQuery.DML.OrderBy) -> String {
        var statement: [String] = []

        let columns = orderBy.columns.map(serialize).joined(separator: ", ")
        statement.append(columns)

        statement.append(serialize(orderByDirection: orderBy.direction))
        return statement.joined(separator: " ")
    }

    /// See `SQLSerializer`.
    public func serialize(orderByDirection: SQLQuery.DML.OrderBy.Direction) -> String {
        switch orderByDirection {
        case .ascending: return "ASC"
        case .descending: return "DESC"
        }
    }
}

