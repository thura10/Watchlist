//
//  ContentView.swift
//  Shared
//
//  Created by Thura Soe Win on 24/5/21.
//

import SwiftUI
import CoreData

enum Screen: String {
    case upcoming, watchlist, settings
}

struct HomeView: View {
    
    @State var screen: Screen? = .upcoming
    
    var body: some View {
        #if os(iOS)
            TabBarView(currentTab: screen)
        #else
            NavigationView {
                SidebarView(currentSelection: $screen)
                Text("Select a page")
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        #endif
    }
}

struct SidebarView: View {
    
    @Binding var currentSelection: Screen?
    
    var body: some View {
        VStack {
            Text("Watchlist")
                .font(.system(size: 20, design: Font.Design.serif))
                .fontWeight(.bold)
                .padding(.vertical, 20)
            List {
                NavigationLink(
                    destination: UpcomingView(),
                    tag: Screen.upcoming,
                    selection: $currentSelection,
                    label: {
                        Label("Upcoming", systemImage: "calendar.badge.clock")
                    }
                )
                NavigationLink(
                    destination: WatchlistView(),
                    tag: Screen.watchlist,
                    selection: $currentSelection,
                    label: {
                        Label("Watchlist", systemImage: "play.rectangle")
                    }
                )
                NavigationLink(
                    destination: SettingsView(),
                    tag: Screen.settings,
                    selection: $currentSelection,
                    label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                )
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 170, minHeight: 400)
            
        }
    }
}

struct TabBarView: View {
    
    @State var currentTab: Screen?
    
    var body: some View {
        TabView(selection: $currentTab) {
            UpcomingView()
                .padding()
                .tabItem {
                    Label("Upcoming", systemImage: "calendar.badge.clock")
                }
                .tag(Screen.upcoming)
            WatchlistView()
                .padding()
                .tabItem {
                    Label("Watchlist", systemImage: "play.rectangle")
                }
                .tag(Screen.watchlist)
            SettingsView()
                .padding()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Screen.settings)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
