//
//  Search.swift
//  Watchlist
//
//  Created by Thura Soe Win on 23/5/21.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @State var searchResult: [SearchResult] = []
    @State var mediaType: MediaType = .multi
    
    @State var searchQuery: String = ""
    
    func getSearchResults() {
        if (!self.searchQuery.isEmpty) {
            TMDb().search(query: self.searchQuery, type: mediaType) { (result) in
                self.searchResult = result;
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(debouncedText: $searchQuery)
                .padding(.vertical)
                .onChange(of: searchQuery, perform: { value in
                    self.getSearchResults()
                })
                
                if (searchResult.count == 0) {
                    Text("Enter a search query")
                        .padding(.top)
                }
                
                List(searchResult) { result in
                    SearchResultItem(item: result, mediaType: mediaType)
                }
                .listStyle(InsetListStyle())
                .listRowBackground(Color.clear)
            }
            .onChange(of: self.mediaType, perform: { value in
                self.getSearchResults()
            })
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Media Type", selection: $mediaType) {
                        Text("All")
                        .tag(MediaType.multi)
                        
                        Text("Movies")
                        .tag(MediaType.movie)
                        
                        Text("TV Shows")
                        .tag(MediaType.tv)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
}

struct SearchResultItem: View {
    
    var item: SearchResult
    @State var mediaType: MediaType
    
    var body: some View {
        HStack {
            item.poster
                .resizable()
                .frame(width: 70, height: 105)
                .cornerRadius(8)
                .padding(.vertical, 7)
            
            VStack(alignment: .leading) {
                Text(item.mediaTitle)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading)
                Text(item.year)
                    .padding(.top, 5.0)
                    .padding(.leading)
            }
            Spacer()
            
            Button(action: {
            }) {
                Image(systemName: "play.rectangle")
                    .foregroundColor(.accentColor)
                    .font(.title2)
            }
            .padding(.trailing, 1) 
            .buttonStyle(PlainButtonStyle())
            
            if (self.mediaType == .tv) {
                Button(action: {
                }) {
                    Image(systemName: "calendar.badge.plus")
                        .foregroundColor(.accentColor)
                        .font(.title2)
                }
                .padding(.trailing, 1)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onAppear(perform: {
            if let type = item.mediaType {
                self.mediaType = MediaType.init(rawValue: type) ?? .tv
            }
        })
    }
}


struct SearchBarView: View {
    
    @Binding var debouncedText : String
    @StateObject private var textObserver = TextFieldObserver()
    
    var body: some View {
    
        VStack {
            TextField("Search...", text: $textObserver.searchText)
                .frame(height: 30)
                .padding(.leading, 5)
                .padding(.horizontal, 20)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.onReceive(textObserver.$debouncedText) { (val) in
            debouncedText = val
        }
    }
}

class TextFieldObserver : ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { t in
                self.debouncedText = t
            } )
            .store(in: &subscriptions)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
