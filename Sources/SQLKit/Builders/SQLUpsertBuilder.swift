/// Builds `SQLInsert` queries with conflict resolution clauses ("upserts").
///
///     conn.upsert(Planet.self)
///         .model(earth)
///         .onConflict(with: ["id"], where: { $0.where(\Planet.type == .smallRocky) }) {
///             $0.set(SQLColumn("name", table: Planet.schema), to: SQLColumn("name", table: "excluded"))
///         }
///         .run()
///
/// See `SQLInsertBuilder`, `SQLUpdateBuilder`, and `SQLPredicateBuilder` for
/// more information.
public final class SQLUpsertBuilder: SQLQueryBuilder {
    
    /// Upsert query being built.
    public var upsert: SQLUpsert
    
    /// See `SQLQueryBuilder`.
    public var database: SQLDatabase
    
    /// See `SQLQueryBuilder`.
    public var query: SQLExpression {
        return self.upsert
    }
    
    /// Creates a new `SQLUpsertBuilder`.
    public init(_ upsert: SQLUpsert, on database: SQLDatabase) {
        self.upsert = upsert
        self.database = database
    }
    
    /// See `SQLInsertBuilder.model(_:)`
    public func model<E>(_ model: E) throws -> Self
        where E: Encodable
    {
        // This silly hack avoids duplicating the implementation of this method
        // found in `SQLInsertBuilder`. There's probably a better way.
        self.upsert.insert.values.append(
            try SQLInsertBuilder(.init(table: SQLIdentifier("")), on: self.database).model(model).insert.values[0]
        )
        return self
    }

    public func columns(_ columns: String...) -> Self {
        self.upsert.insert.columns = columns.map(SQLIdentifier.init)
        return self
    }
    
    public func columns(_ columns: SQLExpression...) -> Self {
        self.upsert.insert.columns = columns
        return self
    }
    
    public func values(_ values: Encodable...) -> Self {
        let row: [SQLExpression] = values.map(SQLBind.init)
        self.upsert.insert.values.append(row)
        return self
    }
    
    public func values(_ values: SQLExpression...) -> Self {
        self.upsert.insert.values.append(values)
        return self
    }
    
    public func onConflict(
        with targets: [String],
        where predicate: ((SQLPredicateBuilder) -> SQLPredicateBuilder)? = nil,
        `do` updatePredicate: (SQLConflictUpdateBuilder) -> SQLConflictUpdateBuilder
    ) -> Self {
        self.upsert.targets = targets.map(SQLIdentifier.init)
        self.upsert.condition = predicate?(SQLPredicateGroupBuilder()).predicate
        self.upsert.action = SQLConflictAction.update(updatePredicate(.init(.init(table: SQLRaw("")), on: self.database)).update)
        return self
    }

    public func onConflict(
        with targets: [SQLExpression],
        where predicate: SQLExpression? = nil,
        update: SQLExpression
    ) -> Self {
        self.upsert.targets = targets
        self.upsert.condition = predicate
        self.upsert.action = update
        return self
    }
    
}

// MARK: Connection

extension SQLDatabase {

    /// Creates a new `SQLUpsertBuilder`.
    ///
    ///     conn.upsert(into: "planets")...
    ///
    /// - parameters:
    ///     - table: Table to insert into.
    /// - returns: Newly created `SQLUpsertBuilder`.
    public func upsert(into table: String) -> SQLUpsertBuilder {
        return self.upsert(into: SQLIdentifier(table))
    }
    
    /// Creates a new `SQLUpsertBuilder`.
    ///
    ///     conn.upsert(into: "planets")...
    ///
    /// - parameters:
    ///     - table: Table to insert into.
    /// - returns: Newly created `SQLUpsertBuilder`.
    public func upsert(into table: SQLExpression) -> SQLUpsertBuilder {
        return .init(.init(table: table), on: self)
    }

}
