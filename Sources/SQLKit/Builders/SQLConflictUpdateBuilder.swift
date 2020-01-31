/// Not intended for direct use by clients. Builds UPDATE clauses to be used in
/// UPSERT queries.
///
/// - TODO: Factor out common code in this class and `SQLUpdateBuilder` instead of repeating everthing.
public final class SQLConflictUpdateBuilder: SQLQueryBuilder, SQLPredicateBuilder {

    /// `Update` query being built.
    public var update: SQLUpdate

    /// See `SQLQueryBuilder`.
    public var database: SQLDatabase
    
    /// See `SQLQueryBuilder`.
    public var query: SQLExpression {
        return self.update
    }
    
    /// See `SQLPredicateBuilder`.
    public var predicate: SQLExpression? {
        get { return self.update.predicate }
        set { self.update.predicate = newValue }
    }
    
    /// Creates a new `SQLConflictUpdateBuilder`.
    public init(_ update: SQLUpdate, on database: SQLDatabase) {
        self.update = update
        self.database = database
    }

    public func set<E>(model: E) throws -> Self where E: Encodable {
        return try SQLQueryEncoder().encode(model).reduce(self) { $0.set(SQLColumn($1.0), to: $1.1) }
    }
    
    public func set(_ column: String, to bind: Encodable) -> Self {
        return self.set(SQLIdentifier(column), to: SQLBind(bind))
    }

    public func set(_ column: SQLExpression, to value: SQLExpression) -> Self {
        let binary = SQLBinaryExpression(left: column, op: SQLBinaryOperator.equal, right: value)
        self.update.values.append(binary)
        return self
    }

    /// Set a column to the value which would have been inserted if a conflict
    /// had not occurred. This method should only be called on update builders
    /// used for an upsert.
    public func set(excludedValueOf column: String) -> Self {
        return self.set(SQLIdentifier(column), to: SQLExcludedColumn(column))
    }
    
    /// Set a column to the value which would have been inserted if a conflict
    /// had not occurred. This method should only be called on update builders
    /// used for an upsert.
    public func set(excludedValueOf column: SQLExpression) -> Self {
        return self.set(column, to: SQLExcludedColumn(column))
    }

    /// Equivalent to calling `set(excludedValueOf:)` for each column the model
    /// contains. This includes any columns that may have been involved in
    /// triggering the conflict.
    public func set<E>(excludedModel model: E) throws -> SQLConflictUpdateBuilder where E: Encodable {
        return try SQLQueryEncoder().encode(model).reduce(self) { $0.set(excludedValueOf: $1.0) }
    }

}
