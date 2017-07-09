import Vapor
import HTTP

final class InstanceController: ResourceRepresentable {

    // TODO: Probs remove or make it auth-ed
    // GET /instances
    func index(req: Request) throws -> ResponseRepresentable {
        return try Instance.all().makeJSON()
    }

    // POST /instances
    func create(request: Request) throws -> ResponseRepresentable {
        let instance = try request.instance()
        try instance.save()
        return instance
    }

    // GET /instances/:instance_id
    func show(req: Request, instance: Instance) throws -> ResponseRepresentable {
        return instance
    }

    // DELETE /instances/:instance_id
    func delete(req: Request, instance: Instance) throws -> ResponseRepresentable {
        try instance.delete()
        return Response(status: .ok)
    }

    // PATCH /instances/:instance_id
    func update(req: Request, instance: Instance) throws -> ResponseRepresentable {
        try instance.update(for: req)
        try instance.save()
        return instance
    }

    func makeResource() -> Resource<Instance> {
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
    func instance() throws -> Instance {
        // TODO: This could return better errors
        guard let json = json else { throw Abort.badRequest }
        return try Instance(json: json)
    }
}

extension InstanceController: EmptyInitializable { }
