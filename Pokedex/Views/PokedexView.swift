//
//  PokedexView.swift
//  PokeDextro (iOS)
//
//  Created by chuynadamas on 10/23/21.
//

import SwiftUI

struct PokedexView: View {
    var body: some View {
        NavigationView {
            PokemonList()
                .navigationTitle("PokeDex")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}
