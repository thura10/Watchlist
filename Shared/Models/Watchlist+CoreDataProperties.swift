//
//  Watchlist+CoreDataProperties.swift
//  Watchlist
//
//  Created by Thura Soe Win on 22/5/21.
//
//

import Foundation
import CoreData
import SwiftUI

enum MediaType: String {
    case movie = "movie"
    case tv = "tv"
    case media = "media"
}

extension Watchlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Watchlist> {
        return NSFetchRequest<Watchlist>(entityName: "Watchlist")
    }

    @NSManaged public var backdrop: Data?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var id: String
    @NSManaged public var overview: String?
    @NSManaged public var poster: Data?
    @NSManaged public var title: String?
    @NSManaged public var year: Int16
    @NSManaged public var type: String
    
    var mediaType: MediaType {
        get {
            MediaType(rawValue: type) ?? .media
        }
        set {
            type = newValue.rawValue
        }
    }

}

extension Watchlist : Identifiable {

}
