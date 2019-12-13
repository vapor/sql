/// Builds `SQLUpdate` queries.
///
///     conn.update(Planet.self)
///         .set(\Planet.name == "Earth")
///         .where(\Planet.name == "Eatrh")
///         .run()
///
/// See `SQLQueryBuilder` and `SQLPredicateBuilder` for more information.
public final class SQLUpdateBuilder: SQLQueryBuilder, SQLPredicateBuilder {
    /// `Update` query being built.
    public var update: SQLUpdate
    
    /// See `SQLQueryBuilder`.
    public var database: SQLDatabase
    
    /// See `SQLQueryBuilder`.
    public var query: SQLExpression {
        return self.update
    }
    
    /// See `SQLWhereBuilder`.
    public var predicate: SQLExpression? {
        get { return self.update.predicate }
        set { self.update.predicate = newValue }
    }
    
    /// Creates a new `SQLDeleteBuilder`.
    public init(_ update: SQLUpdate, on database: SQLDatabase) {
        self.update = update
        self.database = database
    }

    public func set<E>(model: E) throws -> Self where E: Encodable {
        let row = try SQLQueryEncoder().encode(model)
        row.forEach { column, value in
            _ = self.set(SQLColumn(column), to: value)
        }
        return self
    }
    
    /// Sets a column (specified by an identifier) to an expression.
    public func set(_ column: String, to bind: Encodable) -> Self {
        return self.set(SQLIdentifier(column), to: SQLBind(bind))
    }
    
    /// Sets a column (specified by an identifier) to an expression.
    public func set(_ column: SQLExpression, to value: SQLExpression) -> Self {
        let binary = SQLBinaryExpression(left: column, op: SQLBinaryOperator.equal, right: value)
        update.values.append(binary)
        return self
    }
}

// MARK: Connection

extension SQLDatabase {
    /// Creates a new `SQLUpdateBuilder`.
    ///
    ///     conn.update("planets")...
    ///
    /// - parameters:
    ///     - table: Table to update.
    /// - returns: Newly created `SQLUpdateBuilder`.
    public func update(_ table: String) -> SQLUpdateBuilder {
        return self.update(SQLIdentifier(table))
    }
    
    /// Creates a new `SQLUpdateBuilder`.
    ///
    ///     conn.update("planets")...
    ///
    /// - parameters:
    ///     - table: Table to update.
    /// - returns: Newly created `SQLUpdateBuilder`.
    public func update(_ table: SQLExpression) -> SQLUpdateBuilder {
        return .init(.init(table: table), on: self)
    }
}
