//
//  ErrorView.swift
//  PokeDextro (iOS)
//
//  Created by chuynadamas on 10/23/21.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        Text("😵 **Error**").font(.system(size: 60))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NetworkError.noData)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
