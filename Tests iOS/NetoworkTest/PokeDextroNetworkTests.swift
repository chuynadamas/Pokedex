//
//  PokeDextroNetworkTests.swift
//  PokeDextroTests
//
//  Created by chuynadamas on 10/23/21.
//

import XCTest
@testable import Pokedex

class PokeDextroTests: XCTestCase {

    func testExample() async throws {
        let dataModel = PokemonsDataModel()
        await dataModel.fetchPokemons()
        XCTAssertGreaterThan(dataModel.pokemons.count, 1)
    }
    
    func testAPINetwork() async throws {
        let pokemonDataModel = PokemonsDataModel()
        await pokemonDataModel.fetchPokemons()
        XCTAssertGreaterThan(pokemonDataModel.pokemons.count, 1)
    }
    
    func testClearCache() async throws {
        let pokemonDataModel = PokemonsDataModel()
        await pokemonDataModel.fetchPokemons()
        XCTAssertGreaterThan(pokemonDataModel.pokemons.count, 1)
        pokemonDataModel.clearCachePokemons()
        XCTAssertEqual(pokemonDataModel.pokemons.count, 0)
    }
    
    func testFetchNextPage() async throws {
        let pokemonDataModel = PokemonsDataModel()
        await pokemonDataModel.fetchPokemons()
        let lastPokemon = pokemonDataModel.pokemons.last
        await pokemonDataModel.fetchMoreContentIfNeeded(currentItem: lastPokemon)
        XCTAssertGreaterThan(pokemonDataModel.pokemons.count, 10)
    }
}
