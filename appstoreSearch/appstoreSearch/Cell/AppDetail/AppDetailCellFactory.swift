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
    
    func appTitleCell(by table: UITableView, etcAction: @escaping (() -> Void)) -> AppTitleCell {
        let cell =  table.dequeueReusableCell(withIdentifier: AppTitleCell.identifier) as! AppTitleCell
        cell.etcAction = etcAction
        cell.setUI(with: searchResult)
        
        return cell
    }
    
    func appRatingCell(by table: UITableView) -> AppRatingCell {
        let cell =  table.dequeueReusableCell(withIdentifier: AppRatingCell.identifier) as! AppRatingCell
        
        cell.setUI(with: searchResult)
        
        return cell
    }
    
    func newFeatureCell(by table: UITableView, needExtened: Bool, readMore: @escaping (Bool) -> Void) -> NewFeatureCell {
        let cell =  table.dequeueReusableCell(withIdentifier: NewFeatureCell.identifier) as! NewFeatureCell
        
        cell.readMore = readMore
        cell.setUI(with: searchResult, needExtened: needExtened)
        
        return cell
    }
    
    func screenShotCell(by table: UITableView) -> ScreenShotCell {
        let cell = table.dequeueReusableCell(withIdentifier: ScreenShotCell.identifier) as! ScreenShotCell
        
        cell.setScreenShot(with: searchResult)
        
        return cell
    }
    
    func infoTitleCell(by table: UITableView) -> AppInfoTitleCell {
        let cell = table.dequeueReusableCell(withIdentifier: AppInfoTitleCell.identifier) as! AppInfoTitleCell
        //FIXME: 프로토로콜에서 제어하도록 수정
        cell.setTitle(text: "미리보기")
        
        return cell
    }
    
}
