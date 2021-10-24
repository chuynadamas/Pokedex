//
//  PokeDextroNetworkTests.swift
//  PokeDextroTests
//
//  Created by chuynadamas on 10/23/21.
//

import XCTest
@testable import PokeDextro

class PokeDextroTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() async throws {
        let loader = PokemonLoader()
        await loader.load()
        XCTAssertGreaterThan(loader.pokemonData.count, 1)
    }
    
    func testAPINetwork() async throws {
        let pokemonDataModel = PokemonsDataModel()
        await pokemonDataModel.fetchPokemons()
        XCTAssertGreaterThan(pokemonDataModel.pokemons.count, 1)
    }
}
