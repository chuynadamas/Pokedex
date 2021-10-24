//
//  PokemonLoader.swift
//  PokeDextro
//
//  Created by chuynadamas on 10/23/21.
//

import Foundation
import Combine

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
