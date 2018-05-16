extension SQLSerializer {
    /// See `SQLSerializer`.
    public func serialize(column: DataColumn) -> String {
        let escapedName = makeEscapedString(from: column.name)

        let string: String
        if let table = column.table {
            let escapedTable = makeEscapedString(from: table)
            string = "\(escapedTable).\(escapedName)"
        } else {
            string = escapedName
        }
        return string
    }

    /// See `SQLSerializer`.
    public func serialize(column: DataQueryColumn) -> String {
        switch column.storage {
        case .all: return "*"
        case .column(let column, let key):
            let string = serialize(column: column)
            if let key = key {
                return string + " AS " + makeEscapedString(from: key)
            } else {
                return string
            }
        case .computed(let computed, let key):
            let string = serialize(column: computed)
            if let key = key {
                return string + " AS " + makeEscapedString(from: key)
            } else {
                return string
            }
        case .subquery(let subquery, let key):
            let string = serialize(column: subquery)
            return string + " AS " + makeEscapedString(from: key)
        }
    }
}
