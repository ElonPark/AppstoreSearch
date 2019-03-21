//
//  AppDetail.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import Foundation

enum DetailCellType: String {
    case title = "AppTitleCell"
    case rating = "AppRatingCell"
    case feature = "NewFeatureCell"
    case screenShot = "ScreenShotCell"
    case device = "ScreenShotDeivceCell"
    case description = "AppDescriptionCell"
    case developerInfo = "DeveloperInfoCell"
    case infoTitle = "AppInfoTitleCell"
    case info = "AppInfoCell"
}

struct AppDetail {
    var type: DetailCellType
    var needExtened: Bool
    
    init(type: DetailCellType, needExtened: Bool = false) {
        self.type = type
        self.needExtened = needExtened
    }
}
