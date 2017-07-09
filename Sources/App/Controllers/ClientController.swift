import Vapor
import HTTP

final class ClientController: ResourceRepresentable {
    // GET /instances/:instance_id/clients
    func index(req: Request) throws -> ResponseRepresentable {
        guard let instanceId = req.parameters[Client.instanceIdKey]?.int else {
            throw Abort.badRequest
        }

        return
            try Client
                .makeQuery()
                .filter(Client.instanceIdKey, instanceId)
                .all()
                .makeJSON()
    }

    // POST /instances/:instance_id/clients
    func create(request: Request) throws -> ResponseRepresentable {
        let client = try request.client()
        try client.save()
        return client
    }

    // GET /instances/:instance_id/client/:client_id
    func show(req: Request, client: Client) throws -> ResponseRepresentable {
        return client
    }

    // DELETE /instances/:instance_id/client/:client_id
    func delete(req: Request, client: Client) throws -> ResponseRepresentable {
        try client.delete()
        return Response(status: .ok)
    }

    // PATCH /instances/:instance_id/client/:client_id
    func update(req: Request, client: Client) throws -> ResponseRepresentable {
        try client.update(for: req)
        try client.save()
        return client
    }

    func makeResource() -> Resource<Client> {
        return Resource(
            index: index,
            store: create,
            show: show,
            update: update,
            destroy: delete
        )
    }
}

extension Request {
    func client() throws -> Client {
        // TODO: This could return better errors
        guard let json = json else { throw Abort.badRequest }
        return try Client(json: json)
    }
}

extension ClientController: EmptyInitializable { }
