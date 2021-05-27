//
//  Search.swift
//  Watchlist
//
//  Created by Thura Soe Win on 23/5/21.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @Binding var searchResults: [SearchResult]
    @State var mediaType: MediaType = .multi
    
    var filteredResults: [SearchResult] {
        searchResults.filter { item in
            return ((mediaType == .multi) || (item.mediaType == mediaType.rawValue))
        }
    }
    
    var body: some View {
        VStack {
            #if os(iOS)
            SearchBarView(searchResults: $searchResults)
            .padding(.vertical)
            #endif
            
            if filteredResults.count < 1 {
                Text("No results")
                    .padding(.top)
            }
            List(filteredResults) { result in
                SearchResultItem(item: result, mediaType: mediaType)
            }
                .listStyle(InsetListStyle())
                .padding(.top, 10)
        }
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

struct SearchResultItem: View {
    
    var item: SearchResult
    var mediaType: MediaType
    
    init(item: SearchResult, mediaType: MediaType) {
        self.item = item;
        if let type = item.mediaType {
            self.mediaType = MediaType.init(rawValue: type) ?? .tv
        }
        else {
            self.mediaType = mediaType
        }
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: item.posterURL, placeholder: {
                Image("defaultPoster")
                    .resizable()
            })
                .frame(width: 70, height: 105)
                .cornerRadius(8)
                .padding(.vertical, 7)
            
            VStack(alignment: .leading) {
                Text(item.mediaTitle)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading)
                
                HStack {
                    Text(item.year)
                        .padding(.trailing, 20)
                    #if os(macOS)
                    if let rating: Double = item.voteAverage {
                        ForEach(0..<Int(rating/2)) { _ in
                            Image(systemName: "star.fill")
                        }
                        let remainder = rating.truncatingRemainder(dividingBy: 1)
                        if (remainder > 0.4 && remainder < 1) {
                            Image(systemName: "star.leadinghalf.fill")
                        }
                    }
                    #endif
                }
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
    }
}


struct SearchBarView: View {
    
    @Binding var searchResults : [SearchResult]
    @StateObject private var textObserver = TextFieldObserver()

    var onCommit: (() -> Void) = {
        
    }
    
    var body: some View {
        VStack {
            let textField = TextField("Search...", text: $textObserver.searchText,
                onCommit: {
                    self.onCommit()
                }
            )
            #if os(iOS)
            textField
                .font(.body)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(7)
                .padding(.horizontal, 40)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                    }
                )
                .padding(.horizontal, 13)
            #else
            textField
                .font(Font.system(size: 13, weight: .light, design: .default))
                .disableAutocorrection(true)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(5)
                .padding(.leading, 25)
                .background(Color(NSColor.separatorColor))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 6)
                    }
                )
                .padding(.horizontal, 10)
            #endif
        }
        .onReceive(textObserver.$searchResult) { (val) in
            self.searchResults = val
        }
    }
}

class TextFieldObserver : ObservableObject {
    @Published var searchText = ""
    @Published var searchResult : [SearchResult] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { t in
                guard !t.isEmpty else {
                    return self.searchResult = []
                }
                guard let request = TMDb().searchForType(query: t, type: .multi) else {
                    return self.searchResult = []
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                request
                    .tryMap() { element -> Data in
                        guard let httpResponse = element.response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 else {
                                throw URLError(.badServerResponse)
                            }
                        return element.data
                    }
                    .decode(type: SearchData.self, decoder: decoder)
                    .compactMap {
                        return $0.results.filter { result in
                            return (result.mediaType == "movie" || result.mediaType == "tv")
                        }
                    }
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }, receiveValue: { d in
                        self.searchResult = d
                    })
                    .store(in: &self.subscriptions)
            })
            .store(in: &subscriptions)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchResults: .constant([]))
    }
}
