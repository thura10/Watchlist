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
        TabBarView(currentTab: $screen)
            
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
    @State var searchQuery: String = ""
    @State var searchResult: [SearchResult] = [];
    
    var body: some View {
        VStack {
            Text("Watchlist")
                .font(.system(size: 20, design: Font.Design.serif))
                .fontWeight(.bold)
            
            List {
                NavigationLink(
                    destination: SearchView(),
                    tag: Screen.search,
                    selection: $currentSelection,
                    label: {
                        Label(Screen.search.rawValue, systemImage: "magnifyingglass")
                    }
                )
                NavigationLink(
                    destination: UpcomingView(),
                    tag: Screen.upcoming,
                    selection: $currentSelection,
                    label: {
                        Label(Screen.upcoming.rawValue, systemImage: "calendar.badge.clock")
                    }
                )
                NavigationLink(
                    destination: WatchlistView(),
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
    
    @Binding var currentTab: Screen?
    
    var body: some View {
        TabView(selection: $currentTab) {
            
            UpcomingView()
            .tabItem {
                Label(Screen.upcoming.rawValue, systemImage: "calendar.badge.clock")
            }
            .tag(Screen.upcoming)
            
            WatchlistView()
            .tabItem {
                Label(Screen.watchlist.rawValue, systemImage: "play.rectangle")
            }
            .tag(Screen.watchlist)
            
            SearchView()
            .tabItem {
                Label(Screen.search.rawValue, systemImage: "magnifyingglass")
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
