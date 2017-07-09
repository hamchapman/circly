import PostgreSQLProvider

final class Instance: Model {
    let storage = Storage()

    var name: String
    let key: String
    var secret: String
    var apnsToken: String
    var apnsTopic: String

    static let idKey = "id"
    static let nameKey = "name"
    static let keyKey = "key"
    static let secretKey = "secret"
    static let apnsTokenKey = "apns_token"
    static let apnsTopicKey = "apns_topic"

    init(name: String, key: String, secret: String, apnsToken: String, apnsTopic: String) {
        self.name = name
        self.key = key
        self.secret = secret
        self.apnsToken = apnsToken
        self.apnsTopic = apnsTopic
    }

    init(row: Row) throws {
        self.name = try row.get(Instance.nameKey)
        self.key = try row.get(Instance.keyKey)
        self.secret = try row.get(Instance.secretKey)
        self.apnsToken = try row.get(Instance.apnsTokenKey)
        self.apnsTopic = try row.get(Instance.apnsTopicKey)
    }
}

extension Instance: RowRepresentable {
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Instance.nameKey, name)
        try row.set(Instance.keyKey, key)
        try row.set(Instance.secretKey, secret)
        try row.set(Instance.apnsTokenKey, apnsToken)
        try row.set(Instance.apnsTopicKey, apnsTopic)
        return row
    }
}

extension Instance: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { schedule in
            schedule.id()
            schedule.string(Instance.nameKey)
            schedule.string(Instance.keyKey)
            schedule.string(Instance.secretKey)
            schedule.string(Instance.apnsTokenKey)
            schedule.string(Instance.apnsTopicKey)
        })
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Instance: Timestampable { }

extension Instance: SoftDeletable { }

// MARK: JSON

extension Instance: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get(Instance.nameKey),
            key: json.get(Instance.keyKey),
            secret: json.get(Instance.secretKey),
            apnsToken: json.get(Instance.apnsTokenKey),
            apnsTopic: json.get(Instance.apnsTopicKey)
        )
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Instance.idKey, id)
        try json.set(Instance.nameKey, name)
        try json.set(Instance.keyKey, key)
        try json.set(Instance.secretKey, secret)
        try json.set(Instance.apnsTokenKey, apnsToken)
        try json.set(Instance.apnsTopicKey, apnsTopic)
        return json
    }
}

// MARK: HTTP

extension Instance: ResponseRepresentable { }

// MARK: Update

extension Instance: Updateable {
    public static var updateableKeys: [UpdateableKey<Instance>] {
        return [
            UpdateableKey(Instance.nameKey, String.self) { instance, name in
                instance.name = name
            },
            UpdateableKey(Instance.secretKey, String.self) { instance, secret in
                instance.secret = secret
            },
            UpdateableKey(Instance.apnsTokenKey, String.self) { instance, apnsToken in
                instance.apnsToken = apnsToken
            },
            UpdateableKey(Instance.apnsTopicKey, String.self) { instance, apnsTopic in
                instance.apnsTopic = apnsTopic
            }
        ]
    }
}

//extension Instance {
//    func client() throws -> Parent<Client> {
//        return try parent(ownerId)
//    }
//}

