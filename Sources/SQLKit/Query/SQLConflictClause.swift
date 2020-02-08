public struct SQLConflictClause: SQLExpression {

    /// The conflict targets, if any.
    public var targets: [SQLExpression]?

    /// The conflict condition, if any.
    public var condition: SQLExpression?

    /// The action to be taken upon conflicts.
    public var action: SQLExpression
    
    /// Creates a new `SQLConflictClause`.
    public init(action: SQLConflictAction) {
        self.action = action
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        switch serializer.dialect.upsertSyntax {
            case .standard:
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
            case .nonspecific, .nonspecificWithValues:
                if self.targets != nil {
                    print("WARNING: The current database driver does not support conflict target specification!")
                }
                if self.condition != nil {
                    print("WARNING: The current database driver does not support conditional conflict handling!")
                }
                if serializer.dialect.upsertSyntax == .nonspecific {
                    serializer.write("AS `excluded` ")
                }
                serializer.write("ON DUPLICATE KEY UPDATE ")
                action.serialize(to: &serializer)
            case .unsupported:
                print("WARNING: The current database driver does not support single-query conflict resolution (\"upserts\")!")
        }
    }

}
