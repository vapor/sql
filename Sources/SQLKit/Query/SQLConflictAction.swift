public enum SQLConflictAction: SQLExpression {
    case nothing
    case update(SQLExpression)
    case custom(SQLExpression)
    
    public func serialize(to serializer: inout SQLSerializer) {
        switch self {
            case .nothing:
                serializer.write("DO NOTHING")
            case .update(let u):
                serializer.write("DO ")
                u.serialize(to: &serializer)
            case .custom(let c):
                c.serialize(to: &serializer)
        }
    }
}

