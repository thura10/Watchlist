//
//  UpcomingView.swift
//  Watchlist
//
//  Created by Thura Soe Win on 24/5/21.
//

import SwiftUI

struct UpcomingView: View {
    
    @State private var selectedView: Views = .list
    
    enum Views: String {
        case list = "list.bullet"
        case calendar = "calendar"
        case grid = "rectangle.grid.3x2"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("upcoming Page")
            }
            .navigationTitle("Upcoming")
            .frame(minWidth: 400, minHeight: 400)
            .toolbar {
                #if os(macOS)
                ToolbarItem(placement: .primaryAction) {
                    Spacer()
                }
                #endif
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker("View", selection: $selectedView) {
                            Text("As List")
                            .tag(Views.list)
                            
                            Text("As Calendar")
                            .tag(Views.calendar)
                            
                            Text("As Grid")
                            .tag(Views.grid)
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

private struct UpcomingListView: View {
    var body: some View {
        Text("List view")
    }
}

private struct UpcomingCalendarView: View {
    var body: some View {
        Text("Calendar view")
    }
}

private struct UpcomingGridView: View {
    var body: some View {
        Text("Grid view")
    }
}

struct UpcomingView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingView()
    }
}
