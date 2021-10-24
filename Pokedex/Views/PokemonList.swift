//
//  PokemonList.swift
//  PokeDextro
//
//  Created by chuynadamas on 10/23/21.
//

import SwiftUI

struct PokemonList: View {
    @ObservedObject var dataModel: PokemonsDataModel = PokemonsDataModel()
    
    var body: some View {
        List {
            ForEach(dataModel.pokemons) { pokemon in
                PokemonCell(pokemon: pokemon)
            }
        }.task {
            await dataModel.fetchPokemons()
        }
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
