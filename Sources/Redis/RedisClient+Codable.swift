import AsyncKit
import Foundation
import RediStack
import NIOCore

extension RedisClient {
    /// Gets the provided key as a decodable type.
    public func get<D>(_ key: RedisKey, asJSON type: D.Type, jsonDecoder: JSONDecoder = JSONDecoder()) -> EventLoopFuture<D?>
        where D: Decodable
    {
        return self.get(key, as: Data.self).flatMapThrowing { data in
            return try data.flatMap { try jsonDecoder.decode(D.self, from: $0) }
        }
    }

    /// Sets key to an encodable item.
    public func set<E>(_ key: RedisKey, toJSON entity: E, jsonEncoder: JSONEncoder = JSONEncoder()) -> EventLoopFuture<Void>
        where E: Encodable
    {
        do {
            return try self.set(key, to: jsonEncoder.encode(entity))
        } catch {
            return self.eventLoop.makeFailedFuture(error)
        }
    }
    
    /// Sets key to an encodable item with an expiration time.
    public func setex<E>(_ key: RedisKey, toJSON entity: E, expirationInSeconds expiration: Int, jsonEncoder: JSONEncoder = JSONEncoder()) -> EventLoopFuture<Void>
        where E: Encodable
    {
        do {
            return try self.setex(key, to: jsonEncoder.encode(entity), expirationInSeconds: expiration)
        } catch {
            return self.eventLoop.makeFailedFuture(error)
        }
    }
}
