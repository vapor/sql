public struct SQLExcludedColumn: SQLExpression {
    public var name: SQLExpression
    
    public init(_ name: String) {
        self.init(SQLIdentifier(name))
    }
    
    public init(_ name: SQLExpression) {
        self.name = name
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        switch serializer.dialect.upsertSyntax {
            case .standard, .nonspecific:
                SQLColumn(self.name, table: SQLIdentifier("excluded")).serialize(to: &serializer)
            case .nonspecificWithValues:
                SQLFunction("VALUES", args: self.name).serialize(to: &serializer)
            case .unsupported:
                print("WARNING: The current database driver does not support excluded column specification!")
        }
    }
}
