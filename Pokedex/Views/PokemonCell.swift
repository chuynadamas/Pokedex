//
//  PokemonCell.swift
//  PokeDextro (iOS)
//
//  Created by chuynadamas on 10/23/21.
//

import SwiftUI

struct PokemonCell: View {
    
    private let imageWidth = 110.0
    private let cellHeight = 130.0
    
    let pokemon: Pokemon
    
    var body: some View {
        HStack {
            CacheAsyncImage(url: pokemon.url) { phase in
                switch phase {
                case .empty:
                    HStack {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        Spacer()
                    }
                case .success(let image):
                    HStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: imageWidth)
                            .padding(.trailing, 10)
                        PokemonDescription(pokemon: pokemon)
                        Spacer()
                    }
                case .failure(let error):
                    ErrorView(error: error)
                @unknown default:
                    // AsyncImagePhase is not marked as @frozen.
                    // We need to support new cases in the future.
                    Image(systemName: "questionmark")
                }
            }
            .frame(height: cellHeight)
            .padding()
            .listRowSeparator(.hidden)
        }
    }
}

struct PokemonCell_Previews: PreviewProvider {
    static var previews: some View {
        PokemonCell(pokemon: Pokemon.sample)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
