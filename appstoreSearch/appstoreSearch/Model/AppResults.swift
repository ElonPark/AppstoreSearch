//
//  AppResults.swift
//  appstoreSearch
//
//  Created by Elon on 13/04/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit


struct AppResult {
    var appData: ResultElement
    var iconImage: UIImage? = nil
    var name: String
    var category: String
    var rating: Double?
    var ratingCount: Int?
    var price: String
    var screenshots = [UIImage?]()
    var appStoreURL: String
    
    init(_ model: ResultElement) {
        self.appData = model
        self.name = model.trackName
        self.category = model.genres[0]
        self.rating = model.averageUserRatingForCurrentVersion
        self.ratingCount = model.userRatingCountForCurrentVersion
        self.price = model.formattedPrice ?? "무료"
        self.appStoreURL = model.trackViewURL
    }
}
