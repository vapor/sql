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
    var autoIncrementFunction: SQLExpression? { get }
    var enumSyntax: SQLEnumSyntax { get }
    var triggerSyntax: SQLTriggerSyntax { get }
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

public struct SQLTriggerSyntax {
    public struct Create: OptionSet {
        public var rawValue = 0

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let requiresForEachRow = Create(rawValue: 1 << 0)
        public static let supportsBody = Create(rawValue: 1 << 1)
        public static let supportsCondition = Create(rawValue: 1 << 2)
        public static let supportsDefiner = Create(rawValue: 1 << 3)
        public static let supportsForEach = Create(rawValue: 1 << 4)
        public static let supportsOrder = Create(rawValue: 1 << 5)
        public static let supportsUpdateColumns = Create(rawValue: 1 << 6)
        public static let supportsConstraints = Create(rawValue: 1 << 7)
        public static let postgreSQLChecks = Create(rawValue: 1 << 8)
        public static let conditionRequiresParentheses = Create(rawValue: 1 << 9)
    }

    public struct Drop: OptionSet {
        public var rawValue = 0

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let supportsTableName = Drop(rawValue: 1 << 0)
        public static let supportsCascade = Drop(rawValue: 1 << 1)
    }

    public var create = Create()
    public var drop = Drop()

    public init() {}
    public init(create: Create = [], drop: Drop = []) {
        self.create = create
        self.drop = drop
    }
}

extension SQLDialect {
    public var literalDefault: SQLExpression {
        return SQLRaw("DEFAULT")
    }

    public var literalStringQuote: SQLExpression {
        return SQLRaw("'")
    }

    public var supportsIfExists: Bool {
        return true
    }

    public var autoIncrementFunction: SQLExpression? {
        return nil
    }

    public var triggerSyntax: SQLTriggerSyntax {
        return SQLTriggerSyntax()
    }
}
