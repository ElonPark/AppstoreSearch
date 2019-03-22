//
//  AppDetailCellFactory.swift
//  appstoreSearch
//
//  Created by Elon on 22/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit

class AppDetailCellFactory {
    
    let searchResult: ResultElement
    let selectItem: (() -> Void) = {}
    
    init(result: ResultElement) {
        searchResult = result
    }
    
    func appTitleCell(by table: UITableView, data: AppDetailProtocol, etcAction: @escaping (() -> Void)) -> AppTitleCell {
        let cell =  table.dequeueReusableCell(withIdentifier: AppTitleCell.identifier) as! AppTitleCell
        
        cell.etcAction = etcAction
        if let titleData = data as? TitleData {
            cell.setUI(with: titleData)
        }
        
        return cell
    }
    
    func appRatingCell(by table: UITableView, data: AppDetailProtocol) -> AppRatingCell {
        let cell =  table.dequeueReusableCell(withIdentifier: AppRatingCell.identifier) as! AppRatingCell
        if let rating = data as? Rating {
            cell.setUI(with: rating)
        }
        
        return cell
    }
    
    func newFeatureCell(by table: UITableView, data: AppDetailProtocol, readMore: @escaping (Bool) -> Void) -> NewFeatureCell {
        let cell =  table.dequeueReusableCell(withIdentifier: NewFeatureCell.identifier) as! NewFeatureCell
        
        cell.readMore = readMore
        if let releaseNote = data as? ReleaseNote {
            cell.setUI(with: releaseNote)
        }
        
        return cell
    }
    
    func screenShotCell(by table: UITableView, data: AppDetailProtocol) -> ScreenShotCell {
        let cell = table.dequeueReusableCell(withIdentifier: ScreenShotCell.identifier) as! ScreenShotCell
        
        if let screenShot = data as? ScreenShots {
            cell.setScreenShot(with: screenShot)
        }
        
        return cell
    }
    
    func screenShotDeivceCell(by table: UITableView, data: AppDetailProtocol, readMore: @escaping (Bool) -> Void) -> ScreenShotDeivceCell {
        let cell = table.dequeueReusableCell(withIdentifier: ScreenShotDeivceCell.identifier) as! ScreenShotDeivceCell
        
        if let deviceInfo = data as? DeviceInfo {
            cell.setUI(with: deviceInfo)
        }
        
        return cell
    }
    
    func infoTitleCell(by table: UITableView, data: AppDetailProtocol) -> AppInfoTitleCell {
        let cell = table.dequeueReusableCell(withIdentifier: AppInfoTitleCell.identifier) as! AppInfoTitleCell
        
        if let preview = data as? InfoTitle {
            cell.setTitle(text: preview.title)
        }
        
        return cell
    }
    
    func appDescriptionCell(by table: UITableView, data: AppDetailProtocol, readMore: @escaping (Bool) -> Void) -> AppDescriptionCell {
        let cell = table.dequeueReusableCell(withIdentifier: AppDescriptionCell.identifier) as! AppDescriptionCell
        
        cell.readMore = readMore
        if let description = data as? Description {
            cell.setUI(with: description)
        }
        
        return cell
    }
    
    func developerInfoCell(by table: UITableView, data: AppDetailProtocol) -> DeveloperInfoCell {
        let cell = table.dequeueReusableCell(withIdentifier: DeveloperInfoCell.identifier) as! DeveloperInfoCell
        
        if let developerInfo = data as? Info {
            cell.setUI(with: developerInfo)
        }
        
        return cell
    }
    
    func infoCell(by table: UITableView, data: AppDetailProtocol) -> AppInfoCell {
        let cell = table.dequeueReusableCell(withIdentifier: AppInfoCell.identifier) as! AppInfoCell
        
        if let info = data as? Info {
            cell.setUI(with: info)
        }
        
        return cell
    }
    
}
