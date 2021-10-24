//
//  PokemonData.swift
//  PokeDextro
//
//  Created by chuynadamas on 10/23/21.
//

import Foundation
import UIKit

struct PokemonResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

struct Pokemon: Decodable, Identifiable {
    let id: UUID
    let name: String
    
    var url: URL {
        URL(string: "https://img.pokemondb.net/artwork/large/\(name).jpg")!
    }
    
    private enum PokemonKeys: String, CodingKey {
        case name
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = UUID()
    }
}

extension Pokemon {
    static let sample = Pokemon(id: UUID(), name: "bulbasaur")
    //Self.init(id: UUID(), name: "bulbasaur")
}

extension Pokemon: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

