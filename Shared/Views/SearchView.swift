//
//  Search.swift
//  Watchlist
//
//  Created by Thura Soe Win on 23/5/21.
//

import SwiftUI

struct SearchView: View {
    
    @State var type: MediaType

    var body: some View {
        VStack {
            Text("Search Page!")
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(type: .media)
    }
}
