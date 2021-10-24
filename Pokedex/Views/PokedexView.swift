//
//  PokedexView.swift
//  PokeDextro (iOS)
//
//  Created by chuynadamas on 10/23/21.
//

import SwiftUI

struct PokedexView: View {
    @ObservedObject private var loader = PokemonLoader()
    
    var body: some View {
        NavigationView {
            PokemonList(loader: loader)
                .navigationTitle("PokeDex")
                .task {
                    await loader.load()
                }.refreshable {
                    await loader.refresh()
                }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}
