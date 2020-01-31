public struct SQLUpsert: SQLExpression {
    /// The base `INSERT` statement.
    public var insert: SQLInsert
    
    /// The conflict targets, if any.
    public var targets: [SQLExpression]?
    
    /// The conflict condition, if any.
    public var condition: SQLExpression?
    
    /// The action to be taken upon conflicts. If `nil`, the query will behave
    /// like a normal `INSERT`.
    public var action: SQLExpression?
    
    /// Creates a new `SQLUpsert`.
    public init(table: SQLExpression) {
        self.insert = SQLInsert(table: table)
        self.targets = nil
        self.condition = nil
        self.action = nil
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        self.insert.serialize(to: &serializer)
        if let action = self.action {
            serializer.write(" ON CONFLICT")
            if let targets = self.targets {
                serializer.write(" ")
                SQLGroupExpression(targets).serialize(to: &serializer)
            }
            if let condition = self.condition {
                serializer.write(" WHERE ")
                condition.serialize(to: &serializer)
            }
            serializer.write(" ")
            action.serialize(to: &serializer)
        }
    }
}
