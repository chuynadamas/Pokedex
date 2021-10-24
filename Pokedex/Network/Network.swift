//
//  Network.swift
//  PokeDextro
//
//  Created by chuynadamas on 10/23/21.
//

import Foundation
import Combine

// MARK: - Error
enum NetworkError: Error {
    case serverError
    case noData
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverError:
            return NSLocalizedString(
                "There is a problem with the server",
                comment: "")
        case .noData:
            return NSLocalizedString(
                "There is no possible to decode the response",
                comment: "")
        }
    }
}

// MARK: - Network Request Protocol
public protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    
    func decode(_ data: Data) -> ModelType?
    func execute() async throws -> ModelType?
}

public extension NetworkRequest {
    fileprivate func load(_ url: URL) async throws -> ModelType? {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else { throw NetworkError.serverError }
        
        guard let decoded = self.decode(data)
        else { throw NetworkError.noData }
        
        return decoded
    }
}

// MARK: - APIRequest
public class APIRequest<Resource: APIResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
    public func decode(_ data: Data) -> Resource.ModelType? {
        let decoded = try? JSONDecoder().decode(ModelType.self, from: data)
        return decoded
    }
    
    public func execute() async throws -> Resource.ModelType? {
        return try? await load(resource.url)
    }
}

//MARK: - APIPokemonResource
public protocol APIResource {
    associatedtype ModelType: Decodable
    
    var methodPath: String { get }
    var offset: Int { get }
    var limit: Int { get }
}

public extension APIResource {
    var url : URL {
        var components = URLComponents(string: "https://pokeapi.co")!
        components.path = methodPath
        components.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        return components.url!
    }
}

// MARK: - PokemonResources
public struct PokemonsResource: APIResource {
    public typealias ModelType = PokemonResponse
    
    public var methodPath: String {
        return "/api/v2/pokemon"
    }
    
    public var offset: Int
    public var limit: Int
}
