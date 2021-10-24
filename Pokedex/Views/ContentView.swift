//
//  ContentView.swift
//  Shared
//
//  Created by chuynadamas on 10/23/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PokemonList(dataModel: PokemonsDataModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList(dataModel: PokemonsDataModel())
    }
}
