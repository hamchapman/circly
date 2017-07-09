import PostgreSQLProvider

final class Schedule: Model {
    let storage = Storage()

    let interval: Int
    let enabled: Bool
    let name: String
    let clientId: UUID
    let lastSuccessAt: Date?

    static let idKey = "id"
    static let intervalKey = "interval"
    static let enabledKey = "enabled"
    static let nameKey = "name"
    static let clientIdKey = "client_id"
    static let lastSuccessAtKey = "last_success_at"

    init(interval: Int, enabled: Bool, name: String, clientId: UUID) {
        self.interval = interval
        self.enabled = enabled
        self.name = name
        self.clientId = clientId
        self.lastSuccessAt = nil
    }

    init(row: Row) throws {
        self.interval = try row.get(Schedule.intervalKey)
        self.enabled = try row.get(Schedule.enabledKey)
        self.name = try row.get(Schedule.nameKey)
        self.clientId = try row.get(Schedule.clientIdKey)
        self.lastSuccessAt = try row.get(Schedule.lastSuccessAtKey)
    }
}

extension Schedule: RowRepresentable {
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Schedule.intervalKey, interval)
        try row.set(Schedule.enabledKey, enabled)
        try row.set(Schedule.nameKey, name)
        try row.set(Schedule.clientIdKey, clientId)
        try row.set(Schedule.lastSuccessAtKey, lastSuccessAt)
        return row
    }
}

extension Schedule: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { schedule in
            schedule.id()
            schedule.int(Schedule.intervalKey)
            schedule.bool(Schedule.enabledKey)
            schedule.string(Schedule.nameKey)
            schedule.string(Schedule.clientIdKey)
            schedule.date(Schedule.lastSuccessAtKey, optional: true)
        })
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Schedule: Timestampable { }

extension Schedule: SoftDeletable { }

// MARK: JSON

extension Schedule: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            interval: json.get(Schedule.intervalKey),
            enabled: json.get(Schedule.enabledKey),
            name: json.get(Schedule.nameKey),
            clientId: json.get(Schedule.clientIdKey)
//            lastSuccessAt: json.get(Schedule.lastSuccessAtKey)
        )
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Schedule.idKey, id)
        try json.set(Schedule.intervalKey, interval)
        try json.set(Schedule.enabledKey, enabled)
        try json.set(Schedule.nameKey, name)
        try json.set(Schedule.clientIdKey, clientId)
        try json.set(Schedule.lastSuccessAtKey, lastSuccessAt)
        return json
    }
}

// MARK: HTTP

extension Schedule: ResponseRepresentable { }

// MARK: Update

//extension Schedule: Updateable {
//    // Updateable keys are called when `post.update(for: req)` is called.
//    // Add as many updateable keys as you like here.
//    public static var updateableKeys: [UpdateableKey<Schedule>] {
//        return [
//            UpdateableKey(Schedule.enabledKey, Bool.self) { schedule, enabled in
//                schedule.enabled = enabled
//            }
//        ]
//    }
//}

//extension Schedule {
//    func client() throws -> Parent<Client> {
//        return try parent(ownerId)
//    }
//}

