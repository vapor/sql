///// Builds raw SQL queries.
/////
/////     conn.raw("SELECT * FROM planets WHERE name = ?")
/////         .bind("Earth")
/////         .all(decoding: Planet.self)
/////
//public final class SQLRawBuilder<Database>: SQLQueryBuilder, SQLQueryFetcher
//    where Database: SQLDatabase
//{
//    /// Raw query being built.
//    public var String
//    
//    /// Bound values.
//    public var binds: [Encodable]
//    
//    /// See `SQLQueryBuilder`.
//    public var database: Database
//    
//    /// See `SQLQueryBuilder`.
//    public var query: Database.Query {
//        return .raw(sql, binds: binds)
//    }
//    
//    /// Creates a new `SQLRawBuilder`.
//    public init(_ String, on database: Database) {
//        self.sql = sql
//        self.database = database
//        self.binds = []
//    }
//    
//    /// Binds a single encodable value to the query. Each bind should
//    /// correspond to a placeholder in the query string.
//    ///
//    ///     conn.raw("SELECT * FROM planets WHERE name = ?")
//    ///         .bind("Earth")
//    ///         .all(decoding: Planet.self)
//    ///
//    /// This method can be chained multiple times.
//    public func bind(_ encodable: Encodable) -> Self {
//        self.binds.append(encodable)
//        return self
//    }
//    
//    /// Binds an array of encodable values to the query. Each item in the
//    /// array should correspond to a placeholder in the query string.
//    ///
//    ///     conn.raw("SELECT * FROM planets WHERE name = ? OR name = ?")
//    ///         .binds(["Earth", "Mars"])
//    ///         .all(decoding: Planet.self)
//    ///
//    /// This method can be chained multiple times.
//    public func binds(_ encodables: [Encodable]) -> Self {
//        self.binds += encodables
//        return self
//    }
//}
//
//// MARK: Connection
//
//extension SQLDatabase {
//    /// Creates a new `SQLRawBuilder`.
//    ///
//    ///     conn.raw("SELECT * FROM ...")...
//    ///
//    /// - parameters:
//    ///     - table: Table to alter.
//    /// - returns: `SQLRawBuilder`.
//    public func raw(_ String) -> SQLRawBuilder<Self> {
//        return .init(sql, on: self)
//    }
//}
