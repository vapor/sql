public protocol SQLDialect {
    var name: String { get }
    var identifierQuote: SQLExpression { get }
    var literalStringQuote: SQLExpression { get }
    var autoIncrementClause: SQLExpression { get }
    func bindPlaceholder(at position: Int) -> SQLExpression
    func literalBoolean(_ value: Bool) -> SQLExpression
    var literalDefault: SQLExpression { get }
    var supportsIfExists: Bool { get }
    var supportsAutoIncrement: Bool { get }
    var enumSyntax: SQLEnumSyntax { get }
    var upsertSyntax: SQLUpsertSyntax { get }
}

public enum SQLEnumSyntax {
    /// for ex. MySQL, which uses the ENUM literal followed by the options
    case inline

    /// for ex. PostgreSQL, which uses the name of type that must have been
    /// previously created.
    case typeName

    /// for ex. SQL Server, which does not have an enum syntax.
    /// - note: you can likely simulate an enum with a CHECK constraint.
    case unsupported
}

public enum SQLUpsertSyntax {
    /// Standard SQL, e.g. ON CONFLICT and "excluded".
    case standard
    
    /// MySQL, e.g. INSERT IGNORE, ON DUPLICATE KEY UPDATE, and no
    /// support for conflict targets or conditions. Old-style using VALUES()
    case nonspecificWithValues
    
    /// MySQL, e.g. INSERT IGNORE etc. with new-style row/column aliases.
    case nonspecific
    
    /// Something which can't do upserts atomically at all.
    case unsupported
}

extension SQLDialect {
    public var literalDefault: SQLExpression {
        return SQLRaw("DEFAULT")
    }

    public var supportsIfExists: Bool {
        return true
    }
}
