//
//  ContentView.swift
//  Shared
//
//  Created by Thura Soe Win on 24/5/21.
//

import SwiftUI
import CoreData

private enum Screen: String {
    case upcoming = "Upcoming"
    case watchlist = "Watchlist"
    case search = "Search"
}

struct HomeView: View {
    
    @State private var screen: Screen? = .upcoming
    
    var body: some View {
        #if os(iOS)
        TabBarView()
            
        #else
        NavigationView {
            SidebarView(currentSelection: $screen)
            .navigationTitle((screen ?? .upcoming).rawValue)
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())

        #endif
    }
}

private struct SidebarView: View {
    
    @Binding var currentSelection: Screen?
    @State var searchResults: [SearchResult] = []
    
    func showSearchResults() {
        if (!self.searchResults.isEmpty) {
            self.currentSelection = .search
        }
    }
    
    var body: some View {
        VStack {            
            NavigationLink(
                destination: SearchView(searchResults: $searchResults).frame(minWidth: 400),
                tag: Screen.search,
                selection: $currentSelection
            ) {
                SearchBarView(searchResults: $searchResults, onCommit: showSearchResults)
                    .padding(0)
            }
            .padding(.vertical, 10)
            .buttonStyle(PlainButtonStyle())
            .onChange(of: self.searchResults, perform: { value in
                showSearchResults()
            })
            
            List {
                NavigationLink(
                    destination: UpcomingView().frame(minWidth: 400),
                    tag: Screen.upcoming,
                    selection: $currentSelection,
                    label: {
                        Label(Screen.upcoming.rawValue, systemImage: "calendar.badge.clock")
                    }
                )
                NavigationLink(
                    destination: WatchlistView().frame(minWidth: 400),
                    tag: Screen.watchlist,
                    selection: $currentSelection,
                    label: {
                        Label(Screen.watchlist.rawValue, systemImage: "play.rectangle")
                    }
                )
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 170, minHeight: 400)
        }
    }
}

private struct TabBarView: View {
    
    @State var searchResults: [SearchResult] = []
    
    var body: some View {
        TabView() {
            NavigationView {
                UpcomingView()
            }
            .tabItem {
                Image(systemName: "calendar.badge.clock")
                Text(Screen.upcoming.rawValue)
            }
            .tag(Screen.upcoming)
            
            NavigationView {
                WatchlistView()
            }
            .tabItem {
                Image(systemName: "play.rectangle")
                Text(Screen.watchlist.rawValue)
            }
            .tag(Screen.watchlist)
            
            NavigationView {
                SearchView(searchResults: $searchResults)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text(Screen.search.rawValue)
            }
            .tag(Screen.search)
        }
        .edgesIgnoringSafeArea([.horizontal, .top])
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
