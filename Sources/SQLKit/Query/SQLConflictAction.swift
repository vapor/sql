public enum SQLConflictAction: SQLExpression {
    case nothing
    case update(SQLUpdate)
    
    public func serialize(to serializer: inout SQLSerializer) {
        switch self {
            case .nothing: serializer.write("DO NOTHING")
            case .update(var u):
                serializer.write("DO ")
                // - TODO: This results in the serialized string "DO UPDATE  SET". Figure out a means of eliding the extra whitespace.
                u.table = SQLRaw("")
                u.serialize(to: &serializer)
        }
    }
}
