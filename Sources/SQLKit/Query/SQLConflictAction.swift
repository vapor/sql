public enum SQLConflictAction: SQLExpression {
    case nothing
    case update(SQLExpression)
    case custom(SQLExpression)
    
    public func serialize(to serializer: inout SQLSerializer) {
        switch serializer.dialect.upsertSyntax {
            case .standard:
                switch self {
                    case .nothing:
                        serializer.write("DO NOTHING")
                    case .update(let u):
                        serializer.write("DO ")
                        u.serialize(to: &serializer)
                    case .custom(let c):
                        c.serialize(to: &serializer)
                }
            case .nonspecific, .nonspecificWithValues:
                switch self {
                    case .nothing:
                        serializer.write(" ") // TODO: Need a no-op here, how to get a known-good column name?
                        fatalError("No-action conflict resolution in non-specific SQL dialects is currently unimplemented")
                    case .update(let u):
                        u.serialize(to: &serializer)
                    case .custom(let c):
                        c.serialize(to: &serializer)
                }
            case .unsupported:
                print("WARNING: The current database driver does not support conflict actions!")
        }
    }
}

