import PostgreSQLProvider

final class Client: Model {
    let storage = Storage()

    let instanceId: Int
    var customId: String?
    var deviceToken: String

    static let idKey = "id"
    static let instanceIdKey = "instance_id"
    static let customIdKey = "custom_id"
    static let deviceTokenKey = "device_token"

    init(instanceId: Int, customId: String?, deviceToken: String) {
        self.instanceId = instanceId
        self.customId = customId
        self.deviceToken = deviceToken
    }

    init(row: Row) throws {
        self.instanceId = try row.get(Client.instanceIdKey)
        self.customId = try row.get(Client.customIdKey)
        self.deviceToken = try row.get(Client.deviceTokenKey)
    }
}

extension Client: RowRepresentable {
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Client.instanceIdKey, instanceId)
        try row.set(Client.customIdKey, customId)
        try row.set(Client.deviceTokenKey, deviceToken)
        return row
    }
}

extension Client: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { schedule in
            schedule.id()
            schedule.int(Client.instanceIdKey)
            schedule.string(Client.customIdKey, optional: true)
            schedule.string(Client.deviceTokenKey)
        })
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Client: Timestampable { }

extension Client: SoftDeletable { }

// MARK: JSON

extension Client: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            instanceId: json.get(Client.instanceIdKey),
            customId: json.get(Client.customIdKey),
            deviceToken: json.get(Client.deviceTokenKey)
        )
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Client.idKey, id)
        try json.set(Client.instanceIdKey, instanceId)
        try json.set(Client.customIdKey, customId)
        try json.set(Client.deviceTokenKey, deviceToken)
        return json
    }
}

// MARK: HTTP

extension Client: ResponseRepresentable { }

// MARK: Update

extension Client: Updateable {
    public static var updateableKeys: [UpdateableKey<Client>] {
        return [
            UpdateableKey(Client.deviceTokenKey, String.self) { client, deviceToken in
                client.deviceToken = deviceToken
            },
            UpdateableKey(Client.customIdKey, String.self) { client, customId in
                client.customId = customId
            }
        ]
    }
}


//extension Schedule {
//    func client() throws -> Parent<Client> {
//        return try parent(ownerId)
//    }
//}

