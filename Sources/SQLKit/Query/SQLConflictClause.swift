/// TODO: Not even remotely compatible with MySQL syntax.
public struct SQLConflictClause: SQLExpression {

    /// The conflict targets, if any.
    public var targets: [SQLExpression]?

    /// The conflict condition, if any.
    public var condition: SQLExpression?

    /// The action to be taken upon conflicts. If `nil`, the query will behave
    /// like a normal `INSERT`.
    public var action: SQLExpression
    
    /// Creates a new `SQLConflictClause`.
    public init(action: SQLConflictAction) {
        self.action = action
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("ON CONFLICT")
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
