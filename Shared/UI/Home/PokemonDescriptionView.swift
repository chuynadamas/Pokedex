//
//  PokemonDescriptionView.swift
//  PokeDextro (iOS)
//
//  Created by chuynadamas on 10/23/21.
//

import SwiftUI

struct PokemonDescriptionView: View {
    let pokemon: Pokemon
    
    private var attributedText: AttributedString {
        guard let text = try? AttributedString(markdown: "See [More](https://pokemondb.net/pokedex/\(pokemon.name))") else {
            return ""
        }
        
        return text
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("**\(pokemon.name.capitalized)**")
                .font(.system(size: 24))
            Text("*#\(pokemon.id)*")
                .font(.system(size: 18))
                .foregroundColor(.gray)
            
            Text(attributedText)
        }
    }
}

struct PokemonDescription_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDescriptionView(pokemon: Pokemon.sample)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
