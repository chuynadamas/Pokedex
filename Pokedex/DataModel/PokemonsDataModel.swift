//
//  PokemonsDataModel.swift
//  PokeDextro (iOS)
//
//  Created by chuynadamas on 10/24/21.
//

import Foundation

public class PokemonsDataModel: ObservableObject {
    @Published public private(set) var pokemons: [Pokemon] = []
    
    private var request: APIRequest<PokemonsResource>?
    private var offset: Int = 0
    private var limit: Int = 10
    
    public init(){
    }
    
    @MainActor public func fetchMoreContentIfNeeded(currentItem: Pokemon?) async {
        if currentItem == pokemons.last {
            await fetchPokemons()
        }
    }
    
    @MainActor public func fetchPokemons() async {
        let resource = PokemonsResource(offset: self.offset, limit: self.limit)
        let request = APIRequest(resource: resource)
        self.request = request
        
        do {
            pokemons += try await request.execute() ?? []
            self.offset += 10
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor public func refreshPokemonsList() async {
        clearCachePokemons()
        await fetchPokemons()
    }
    
    func clearCachePokemons() {
        pokemons.removeAll()
        Pokemon.totalFound = 0
        self.offset = 0
    }
}
