//
//  TMdbApiService.swift
//  Watchlist
//
//  Created by Thura Soe Win on 23/5/21.
//

import Foundation
import SwiftUI

class TMDb {
    let apiKey: String = "ef0b54d540e68c2dd4a0ff428b46161c";
    let baseUrl: String = "https://api.themoviedb.org/3";
    
    init() {}
    
    func search(query: String, type: MediaType, completion: @escaping ([SearchResult]) -> ()) {
        if (type == .multi) {
            searchType(query: query, type: type.rawValue) { (result) in
                let filteredResult = result.filter { (item) -> Bool in
                    return item.mediaType != "person"
                }
                completion(filteredResult)
            }
        }
        else {
            searchType(query: query, type: type.rawValue) { (result) in
                completion(result)
            }
        }
        
    }
    
    private func searchType(query: String, type: String, completion: @escaping ([SearchResult]) -> ()) {
        
        let queryItems = [URLQueryItem(name: "api_key", value: self.apiKey), URLQueryItem(name: "language", value: "en-US"), URLQueryItem(name: "query", value: query)]
        
        var urlComp = URLComponents(string: baseUrl + "/search/\(type)")
        urlComp?.queryItems = queryItems
    
        guard let url = urlComp?.url else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let data = data else { return print(error?.localizedDescription ?? "API Error") }
            
            let result = try! decoder.decode(SearchData.self, from: data)
            
            DispatchQueue.main.async {
                completion(result.results)
            }
        }
        .resume()
    }
    
}

struct SearchData: Codable {
    let page, totalResults, totalPages: Int
    let results: [SearchResult]
}

struct SearchResult: Codable, Identifiable {
    
    var id: Int?
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
    
    var poster: Image {
        get {
            
            let defaultImg = Image(uiImage: UIImage(named: "defaultPoster")!)
            
            guard let image = posterPath else {
                return defaultImg
            }

            let url = URL(string: "https://image.tmdb.org/t/p/w185" + image)!;
            do {
                return try Image(uiImage: UIImage(data: Data.init(contentsOf: url))!)
            }
            catch {
                return defaultImg
            }
        }
    }
    
    var backdrop: Image? {
        get {
            
            guard let image = self.backdropPath else {
                return nil
            }
            let url =  URL(string: "https://image.tmdb.org/t/p/original" + image)!
            do {
                return try Image(uiImage: UIImage(data: Data.init(contentsOf: url))!)
            }
            catch {
                return nil
            }
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
