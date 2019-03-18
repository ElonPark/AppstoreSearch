//
//  SerachResult.swift
//  appstoreSearch
//
//  Created by Elon on 16/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import Foundation

struct Result: Codable {
    let resultCount: Int
    let results: [ResultElement]
    
    init(data: Data?) throws {
        guard let responseData = data else { throw APIError.responseData }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Result.self, from: responseData)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw APIError.jsonDecode
        }
        
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
}
    

struct ResultElement: Codable {
    let screenshotURLs: [String]
    let ipadScreenshotURLs: [String]
    let appletvScreenshotURLs: [String]
    let artistViewURL: String
    let artworkURL60: String
    let artworkURL100: String
    let artworkURL512: String
    let isGameCenterEnabled: Bool
    let supportedDevices: [String]
    let advisories: [String]
    let kind: String
    let features: [String]
    let averageUserRatingForCurrentVersion: Double?
    let languageCodesISO2A: [String]
    let fileSizeBytes: String
    let userRatingCountForCurrentVersion: Int?
    let trackContentRating: String
    let contentAdvisoryRating: String
    let trackCensoredName: String
    let trackViewURL: String
    let currentVersionReleaseDate: Date
    let releaseDate: Date
    let primaryGenreName: String
    let primaryGenreID: Int
    let sellerName: String
    let isVppDeviceBasedLicensingEnabled: Bool
    let minimumOSVersion: String
    let formattedPrice: String
    let genreIDs: [String]
    let currency: String
    let wrapperType: String
    let version: String
    let trackID, artistID: Int
    let artistName: String
    let genres: [String]
    let price: Int
    let description: String
    let bundleID: String
    let trackName: String
    let releaseNotes: String?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let sellerURL: String?
    
    enum CodingKeys: String, CodingKey {
        case screenshotURLs = "screenshotUrls"
        case ipadScreenshotURLs = "ipadScreenshotUrls"
        case appletvScreenshotURLs = "appletvScreenshotUrls"
        case artistViewURL = "artistViewUrl"
        case artworkURL60 = "artworkUrl60"
        case artworkURL100 = "artworkUrl100"
        case artworkURL512 = "artworkUrl512"
        case isGameCenterEnabled
        case supportedDevices
        case advisories
        case kind
        case features
        case averageUserRatingForCurrentVersion
        case languageCodesISO2A
        case fileSizeBytes
        case userRatingCountForCurrentVersion
        case trackContentRating
        case contentAdvisoryRating
        case trackCensoredName
        case trackViewURL = "trackViewUrl"
        case currentVersionReleaseDate
        case releaseDate
        case primaryGenreName
        case primaryGenreID = "primaryGenreId"
        case sellerName
        case isVppDeviceBasedLicensingEnabled
        case minimumOSVersion = "minimumOsVersion"
        case formattedPrice
        case genreIDs = "genreIds"
        case currency
        case wrapperType
        case version
        case trackID = "trackId"
        case artistID = "artistId"
        case artistName
        case genres
        case price
        case description
        case bundleID = "bundleId"
        case trackName
        case releaseNotes
        case averageUserRating
        case userRatingCount
        case sellerURL = "sellerUrl"
    }
}
