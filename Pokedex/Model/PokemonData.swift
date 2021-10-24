//
//  PokemonData.swift
//  PokeDextro
//
//  Created by chuynadamas on 10/23/21.
//

import Foundation

struct PokemonResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

public struct Pokemon: Identifiable {
    public let id: UUID
    public let name: String
    
    var url: URL {
        URL(string: "https://img.pokemondb.net/artwork/large/\(name).jpg")!
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
}

extension Pokemon: Decodable {
    private enum PokemonKeys: String, CodingKey {
        case name
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = UUID()
    }
}

extension Pokemon: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}


extension Pokemon {
    static let sample = Self.init(id: UUID(), name: "bulbasaur")
}

// MARK: - Wrapper
public struct Wrapper<T: Decodable>: Decodable {
    let results: [T]
}
