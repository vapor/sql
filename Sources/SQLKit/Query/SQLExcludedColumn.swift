public struct SQLExcludedColumn: SQLExpression {
    public var name: SQLExpression
    
    public init(_ name: String) {
        self.init(SQLIdentifier(name))
    }
    
    public init(_ name: SQLExpression) {
        self.name = name
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        // serializer.dialect.excludedValueExpression(for: self.name).serialize(to: &serializer)
        SQLColumn(self.name, table: SQLIdentifier("excluded")).serialize(to: &serializer)
    }
}
