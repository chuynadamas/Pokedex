//
//  PokemonList.swift
//  PokeDextro
//
//  Created by chuynadamas on 10/23/21.
//

import SwiftUI

struct PokemonList: View {
    @ObservedObject var loader: PokemonLoader
    
    var body: some View {
        List {
            ForEach(loader.pokemonData) { pokemon in
                PokemonCell(pokemon: pokemon)
                .task {
                    if pokemon == loader.pokemonData.last {
                        await loader.nextPage()
                    }
                }
            }
        }
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList(loader: PokemonLoader())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
