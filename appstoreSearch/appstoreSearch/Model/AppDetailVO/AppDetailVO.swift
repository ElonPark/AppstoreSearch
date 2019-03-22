//
//  Description.swift
//  appstoreSearch
//
//  Created by Elon on 22/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit

struct TitleData: AppDetailProtocol {
    
    var type: DetailCellType
    var iconURLString: String
    var title: String
    var subTitle: String
    var price: String?
    var appStoreURL: String
}

struct Rating: AppDetailProtocol {
    var type: DetailCellType
    var userRating: Double?
    var userRatingCount: Int?
    var category: [String]
    var contentRating: String
}

class Description: AppDetailProtocol {
    
    var type: DetailCellType
    var text: String
    var needExtened: Bool
    
    init(type: DetailCellType, text: String, needExtened: Bool) {
        self.type = type
        self.text = text
        self.needExtened = needExtened
    }
}

class ReleaseNote: Description {
    
    var version: String
    var updateDate: Date
    
    init(type: DetailCellType, version: String, updateDate: Date, text: String, needExtened: Bool) {
        self.version = version
        self.updateDate = updateDate
        super.init(type: type, text: text, needExtened: needExtened)
    }
}

struct ScreenShots: AppDetailProtocol {
    
    var type: DetailCellType
    var urlStrings: [String]
    
    init(type: DetailCellType, urlStrings: [String]) {
        self.type = type
        self.urlStrings = urlStrings
    }
}

struct InfoTitle: AppDetailProtocol {
    
    var type: DetailCellType
    var title: String
}

class Info: AppDetailProtocol {
    var type: DetailCellType
    var title: String
    var subTitle: String
    var description: String
    var needExtened: Bool
    
    init(type: DetailCellType, title: String, subTitle: String, description: String, needExtened: Bool = false) {
        self.type = type
        self.title = title
        self.subTitle = subTitle
        self.description = description
        self.needExtened = needExtened
    }
}

struct DeviceInfo: AppDetailProtocol {
    var type: DetailCellType
    var title: String
    var needExtened: Bool
    var icon: UIImage?
    var screenShots: [String]
}
