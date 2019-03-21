//
//  AppDetailViewController.swift
//  appstoreSearch
//
//  Created by Elon on 20/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension AppDetailViewController {
    
    func setRrefersLargeTitles() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.prefersLargeTitles = false
    }
    
    func navigationBarShadow(isHidden: Bool) {
        navigationController?.navigationBar.setValue(isHidden, forKey: "hidesShadow")
    }
    
    func setDeatailTableView() {
        detailTableView.delegate = nil
        detailTableView.dataSource = nil
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.estimatedRowHeight = 100
    }
    
    func setAppMenu() {
        appMenu = [
            AppDetail(type: .title),
            AppDetail(type: .rating),
            AppDetail(type: .feature),
            AppDetail(type: .infoTitle),
            AppDetail(type: .screenShot),
            AppDetail(type: .device),
            AppDetail(type: .description),
            AppDetail(type: .developerInfo),
            AppDetail(type: .infoTitle),
            AppDetail(type: .info)
        ]
    }
    
    
    func showShareSheet() {
        let appStoreURL = "https://tunes.apple.com/app/id"
        guard let appID = searchResult?.trackID,
            let url = URL(string: appStoreURL + String(appID)) else {
                return
        }
        
        let items: [Any] = [url, url.absoluteString]
        let activityVC = UIActivityViewController(activityItems: items,
                                                  applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    func moveAppStoreOtherApp() {
        guard let artistID = searchResult?.artistID else { return }
        let appStoreURLString = "itms-apps://itunes.apple.com/developer/id\(artistID)"
        guard let url = URL(string: appStoreURLString) else { return }
        UIApplication.shared.open(url)
    }
 
    func etcAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let share = UIAlertAction(title: "앱 공유하기", style: .default) { [weak self] (_) in
            self?.showShareSheet()
        }

        let showOtherApp = UIAlertAction(title: "이 개발자의 다른 앱 보기", style: .default) { [weak self] (_) in
            self?.moveAppStoreOtherApp()
        }
 
        let alignmentMode = CATextLayerAlignmentMode.left
        let key = "titleTextAlignment"
        share.setValue(alignmentMode, forKey: key)
        showOtherApp.setValue(alignmentMode, forKey: key)
        //TODO: 이미지 아이콘 추가
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(share)
        alert.addAction(showOtherApp)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func readMore(with index: Int, needExtened: Bool) {
        appMenu[index].needExtened = needExtened
       
        dataSource.accept(appMenu)
    }
    
    func dataBinding() {
        dataSource.observeOn(MainScheduler.instance)
            .bind(to: detailTableView.rx.items) { [unowned self] table, index, model in
                
                switch model.type {
                case .title:
                    return self.cellFactory.appTitleCell(by: table, etcAction: self.etcAction)
                case .rating:
                    return self.cellFactory.appRatingCell(by: table)
                case .feature:
                    return self.cellFactory.newFeatureCell(by: table,
                                                           needExtened: model.needExtened
                    ) { [weak self] (needExtened) in
                        self?.readMore(with: index, needExtened: needExtened)
                    }
                case .screenShot:
                    return self.cellFactory.screenShotCell(by: table)
                case .device:
                    break
                case .description:
                    break
                case .developerInfo:
                    break
                case .infoTitle:
                    return self.cellFactory.infoTitleCell(by: table)
                case .info:
                    break
                }
                
                return UITableViewCell()
            }
        .disposed(by: disposeBag)
    }
}

class AppDetailViewController: UIViewController {

    
    @IBOutlet weak var detailTableView: UITableView!
    
    var searchResult: ResultElement!
    var cellFactory: AppDetailCellFactory!
    let disposeBag = DisposeBag()
    
    var appMenu = [AppDetail]()
    
    ///FIXME: 임시 데이터
    lazy var dataSource = BehaviorRelay(value: appMenu)
    
    class func instantiateVC() -> AppDetailViewController {
        let identifier = "AppDetailViewController"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let appDetailVC = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return appDetailVC as! AppDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDeatailTableView()
        dataBinding()
        setAppMenu()
        dataSource.accept(appMenu)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRrefersLargeTitles()
        navigationBarShadow(isHidden: true)
    }
}
