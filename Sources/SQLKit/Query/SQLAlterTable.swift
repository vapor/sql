/// `ALTER TABLE` query.
///
///     conn.alter(table: Planet.self)
///         .column(for: \.name)
///         .run()
///
/// See `SQLAlterTableBuilder` for more information.
public struct SQLAlterTable: SQLExpression {
    public var name: SQLExpression
    /// Columns to add.
    public var addColumns: [SQLExpression]
    /// Columns to update.
    public var modifyColumns: [SQLExpression]
    /// Columns to delete.
    public var dropColumns: [SQLExpression]
    
    /// Creates a new `SQLAlterTable`. See `SQLAlterTableBuilder`.
    public init(name: SQLExpression) {
        self.name = name
        self.addColumns = []
        self.modifyColumns = []
        self.dropColumns = []
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if !serializer.dialect.alterTableSyntax.allowsBatch && self.addColumns.count + self.modifyColumns.count + self.dropColumns.count > 1 {
            serializer.database.logger.warning("Database does not support batch table alterations. You will need to rewrite as individual alter statements.")
        }

        let additions = self.addColumns.map { column in
            (SQLRaw("ADD"), column)
        }

        let removals = self.dropColumns.map { column in
            (SQLRaw("DROP"), column)
        }

        let modifications = serializer.dialect.alterTableSyntax.alterColumnDefinitionClause.map { clause in
            self.modifyColumns.map { column in
                (clause, column)
            }
        } ?? []

        let alterations = additions + removals + modifications

        serializer.statement {
            $0.append("ALTER TABLE")
            $0.append(self.name)
            for (idx, alteration) in alterations.enumerated() {
                if idx > 0 {
                    $0.append(",")
                }
                $0.append(alteration.0)
                $0.append(alteration.1)
            }
        }
    }
}
