//
//  AppDetailFactory.swift
//  appstoreSearch
//
//  Created by Elon on 22/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit

struct AppDetailFactory {
    
    var result: ResultElement
    
    init(result: ResultElement) {
        self.result = result
    }
    
    func title() -> TitleData {
        return TitleData(type: .title,
                         iconURLString: result.artworkURL512,
                         title: result.trackName,
                         subTitle: result.artistName,
                         price: result.formattedPrice,
                         appStoreURL: result.trackViewURL)
    }
    
    func rating() -> Rating {
        return Rating(type: .rating,
                      userRating: result.averageUserRatingForCurrentVersion,
                      userRatingCount: result.userRatingCountForCurrentVersion,
                      category: result.genres,
                      contentRating: result.trackContentRating)
    }
    
    func feature() -> ReleaseNote {
        return ReleaseNote(type: .feature,
                           version: result.version,
                           updateDate: result.currentVersionReleaseDate,
                           text: result.releaseNotes ?? "",
                           needExtened: false)
    }
    
    func preview() -> InfoTitle {
        return InfoTitle(type: .infoTitle, title: "미리보기")
    }
    
    func screenShot() -> ScreenShots {
        return ScreenShots(type: .screenShot, urlStrings: result.screenshotURLs)
    }
    
    func deviceInfo() -> DeviceInfo {
        //var title = "iPhone"
        
        //if result.ipadScreenshotURLs.count > 0 {
        //    title = "iPad용 앱 제공"
        //}
        
        return DeviceInfo(type: .device,
                          title: "iPhone",
                          needExtened: false,
                          icon: UIImage(named: "iPhoneIcon"),
                          screenShots: result.ipadScreenshotURLs)
    }
    
    func description() -> Description {
        return Description(type: .description,
                           text: result.description,
                           needExtened: false)
    }
    
    func developerInfo() -> Info {
        return Info(type: .developerInfo,
                    title: result.sellerName,
                    subTitle: "개발자",
                    description: String(result.artistID))
    }
    
    func infoTitle() -> InfoTitle {
        return InfoTitle(type: .infoTitle, title: "정보")
    }
    
    func seller() -> Info {
        return Info(type: .info,
                    title: "판매자",
                    subTitle: result.sellerName,
                    description: "")
    }
    
    func size() -> Info {
        var fileSize = "0Bytes"
        
        if var file = Double(result.fileSizeBytes) {
            
            var count =  0
            while file > 1024.0 {
                file /= 1024.0
                count += 1
            }
            
            var unit = "Bytes"
            switch count {
            case 1:
                unit = "KB"
            case 2:
                unit = "MB"
            case 3:
                unit = "GB"
            case 4:
                unit = "PB"
            default:
                break
            }
            
            fileSize = "\(file.rounded(toPlaces: 1, rule: .up))" + unit
        }
        
        return Info(type: .info,
                    title: "크기",
                    subTitle: fileSize,
                    description: "")
    }
    
    
    func category() -> Info {
        return Info(type: .info,
                    title: "카테고리",
                    subTitle: result.genres[0],
                    description: "")
    }
    
    func compatibility() -> Info {
        let description = result.supportedDevices.joined(separator: ", ")
        
        return Info(type: .info,
                    title: "호환성",
                    subTitle: "iPhone용",
                    description: description)
    }
    
    func language() -> Info {
        let locale = NSLocale(localeIdentifier: "KO")
        let code = result.languageCodesISO2A[0]
        var title = locale.displayName(forKey: .identifier, value: code) ?? ""
        
        var description = ""
        if result.languageCodesISO2A.count > 1 {
            title += " 외 \(result.languageCodesISO2A.count - 1)개"
            
            description = result.languageCodesISO2A.compactMap {
                locale.displayName(forKey: .identifier, value: $0)
                }.joined(separator: ", ")
        }

        return Info(type: .info,
                    title: "언어",
                    subTitle: title,
                    description: description)
    }
    
    func age() -> Info {
        return Info(type: .info,
                    title: "연령",
                    subTitle: result.trackContentRating,
                    description: "")
    }
    
    func developerSite() -> Info {
        return Info(type: .developerSite,
                    title: "개발자 웹사이트",
                    subTitle: "",
                    description: "")
        
    }
}
