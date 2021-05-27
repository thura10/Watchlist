//
//  TMdbApiService.swift
//  Watchlist
//
//  Created by Thura Soe Win on 23/5/21.
//

import Foundation
import SwiftUI
import Combine

class TMDb {
    let apiKey: String = "ef0b54d540e68c2dd4a0ff428b46161c";
    let baseUrl: String = "https://api.themoviedb.org/3";
    
    init() {}
    
    func searchForType(query: String, type: MediaType) -> Publishers.Share<URLSession.DataTaskPublisher>? {
        let queryItems = [URLQueryItem(name: "api_key", value: self.apiKey), URLQueryItem(name: "language", value: "en-US"), URLQueryItem(name: "query", value: query)]
        
        var urlComp = URLComponents(string: baseUrl + "/search/\(type.rawValue)")
        urlComp?.queryItems = queryItems
        
        // THIS DOES NOT FILTER OUT ACTOR ITEMS IN MULTI SEARCH
    
        guard let url = urlComp?.url else { return nil }
        return URLSession.shared.dataTaskPublisher(for: url).share()
    }
    
}

struct SearchData: Codable {
    let page, totalResults, totalPages: Int
    let results: [SearchResult]
}

struct SearchResult: Codable, Identifiable, Equatable {
    
    var id: Int
    var popularity: Double?
    var posterPath: String?
    var backdropPath: String?
    var title: String?
    var voteAverage: Double?
    var overview, releaseDate, tagline: String?
    var mediaType: String?
    
    var name: String?
    var firstAirDate: String?
    
    init(id: Int, posterPath: String, backdropPath: String, title: String, voteAverage: Double, overview: String, releaseDate: String, tagline: String, mediaType: String) {
        self.id = id
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.popularity = 0.0
        self.voteAverage = voteAverage
        self.name = nil
        self.firstAirDate = ""
        self.tagline = tagline
        self.mediaType = mediaType
    }
    
    var posterURL: URL? {
        get {
            guard let image = posterPath else {
                return nil
            }
            return URL(string: "https://image.tmdb.org/t/p/w185" + image)!
        }
    }
    
    var backdropURL: URL? {
        get {
            guard let image = self.backdropPath else {
                return nil
            }
            return URL(string: "https://image.tmdb.org/t/p/original" + image)!
        }
    }
    
    var year: String {
        get {
            guard let date = self.releaseDate else {
                return String((self.firstAirDate ?? "").prefix(4))
            }
            return String(date.prefix(4))
        }
    }
    var mediaTitle: String {
        get {
            return (self.title ?? self.name) ?? ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, popularity, posterPath, backdropPath, title, voteAverage, overview, releaseDate, name, firstAirDate, tagline, mediaType
    }
}
