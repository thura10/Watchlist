//
//  WatchlistView.swift
//  Watchlist
//
//  Created by Thura Soe Win on 24/5/21.
//

import SwiftUI

struct WatchlistView: View {
    
    @State private var mediaType: MediaType = .movie
    @State private var selectedView: Views = .card
    
    enum Views: String {
        case card = "rectangle.stack"
        case grid = "rectangle.grid.3x2"
        case list = "list.bullet"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                switch selectedView {
                    case .card:
                        WatchlistCardView();
                    case .grid:
                        WatchlistGridView();
                    case .list:
                        WatchlistListView();
                }
            }
            .navigationTitle("Watchlist")
            .navigationViewStyle(DefaultNavigationViewStyle())
            .frame(minWidth: 400, minHeight: 400)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Media Type", selection: $mediaType) {
                        Text("Movies")
                        .tag(MediaType.movie)
                        
                        Text("TV Shows")
                        .tag(MediaType.tv)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                #if os(macOS)
                ToolbarItem(placement: .primaryAction) {
                    Spacer()
                }
                #endif

                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker("View", selection: $selectedView) {
                            Text("As Cards")
                            .tag(Views.card)
                            
                            Text("As Grid")
                            .tag(Views.grid)
                            
                            Text("As List")
                            .tag(Views.list)
                        }
                        .pickerStyle(InlinePickerStyle())
                    }
                    label: {
                        Label("View", systemImage: selectedView.rawValue)
                    }
                }
            }
        }
    }
}

private struct WatchlistCardView: View {
    
    var body: some View {
        Text("Card view")
    }
}

private struct WatchlistGridView: View {
    
    var body: some View {
        Text("Grid view")
    }
}

private struct WatchlistListView: View {
    
    var body: some View {
        Text("List view")
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}
