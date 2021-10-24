//
//  PokemonLoader.swift
//  PokeDextro
//
//  Created by chuynadamas on 10/23/21.
//

import Foundation
import Combine

enum NetworkError: Error {
    case serverError
    case noData
}

// MARK: - Network Request
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
    public func decode(_ data: Data) -> [Resource.ModelType]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let wrapper = try? decoder.decode(Wrapper<Resource.ModelType>.self, from: data)
        return wrapper?.results
    }
    
    public func execute() async throws -> [Resource.ModelType]? {
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

public struct PokemonsResource: APIResource {
    public typealias ModelType = Pokemon
    
    public var methodPath: String {
        return "/api/v2/pokemon"
    }
    
    public var offset: Int
    public var limit: Int
}

enum PokemonError: Error {
    case serverError
    case noData
}

extension PokemonError: LocalizedError {
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

// MARK: - Pokemon Loader Old implementation
class PokemonLoader: ObservableObject {
    @Published private(set) var pokemonData: [Pokemon] = []
    
    private let urlSession = URLSession(configuration: .default)
    private let limit = 10
    
    private var offset = 0
    
    func restartPagination() {
        offset = 0
        pokemonData.removeAll()
    }
    
    private func getPokemons() async throws -> [Pokemon] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)&offset=\(offset)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else { throw  PokemonError.serverError }
        
        guard let decoded = try? JSONDecoder().decode(PokemonResponse.self, from: data)
        else { throw PokemonError.noData }
        
        offset += limit
        return decoded.results
    }
    
    @MainActor func load() async {
        do {
            pokemonData += try await getPokemons()
        } catch {
            print("Error: ", error.localizedDescription)
        }
    }
    
    @MainActor func nextPage() async {
        do {
            pokemonData += try await getPokemons()
        } catch {
            print("Error", error.localizedDescription)
        }
    }
    
    @MainActor func refresh() async {
        restartPagination()
        await load()
    }
}
