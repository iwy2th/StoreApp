//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Iwy2th on 29/06/2023.
//

import Foundation
class ResultArray: Codable {
  var resultCount = 0
  var results = [SearchResult]()
}
class SearchResult: Codable, CustomStringConvertible {
  enum CodingKeys: String , CodingKey {
    case imageSmall = "artworkUrl60"
    case imageLarge = "artworkUrl100"
    case itemGenre = "primaryGenreName"
    case bookGenre = "genres"
    case itemPrice = "price"
    case kind, artistName, currency
    case trackPrice, trackName, trackViewUrl
    case collectionViewUrl, collectionName, collectionPrice
  }
  var description: String {
    return "\nResult - Name: \(name), Kind: \(kind ?? "None"), Artist Name: \(artistName ?? "None")"
  }
  var trackPrice: Double? = 0.0
  var currency = ""
  var imageSmall = ""
  var imageLarge = ""
  var trackViewUrl: String?
  var collectionName: String?
  var collectionViewUrl: String?
  var collectionPrice: Double?
  var itemGenre: String?
  var itemPrice: Double?
  var bookGenre: [String]?
  var kind: String? = ""
  var artistName: String? = ""
  var trackName: String? = ""
  var name: String {
    return trackName ?? collectionName ??  ""
  }
  var storeURL: String {
    return trackViewUrl ?? collectionViewUrl ?? ""
  }
  var price: Double {
    return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
  }
  var genre: String {
    if let genre = itemGenre {
      return genre
    } else if let genres = bookGenre {
      return genres.joined(separator: ", ")
    }
    return ""
  }
  var type: String {
    let kind =  self.kind ?? "audiobook"
    switch kind {
    case  "album": return "Album"
    case "audiobook": return "Audio Book"
    case "book": return "Book"
    case "ebook": return "E-Book"
    case "feature-movie": return "Movie"
    case "music-video": return "Music Video"
    case "podcast": return "Podcast"
    case "software": return "App"
    case "song": return "Song"
    case "tv-episode": return "TV Episode"
    default: break
    }
    return "Unknown"
  }
  var artist: String {
    return artistName ?? "" 
  }
}
