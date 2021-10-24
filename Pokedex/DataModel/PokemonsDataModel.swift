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
    
    public init(){
    }
    
    @MainActor public func fetchPokemons() async {
        let resource = PokemonsResource(offset: 0, limit: 10)
        let request = APIRequest(resource: resource)
        self.request = request
        
        do {
            pokemons = try await request.execute() ?? []
        } catch {
            print(error.localizedDescription)
        }
    }
}
