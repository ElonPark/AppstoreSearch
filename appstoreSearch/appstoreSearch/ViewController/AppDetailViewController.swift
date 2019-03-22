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
import SnapKit

extension AppDetailViewController {
    
    func setRrefersLargeTitles() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.prefersLargeTitles = false
    }
    
    func navigationBarShadow(isHidden: Bool) {
        navigationController?.navigationBar.setValue(isHidden, forKey: "hidesShadow")
    }
    
    //FIXME: 작업중
    func setNavigationBarIcon() {
        //TODO: 네비게이션바 가운데 앱아이콘 추가
        guard let urlString = searchResult?.artworkURL60 else { return }
        Log.verbose(urlString)
        
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        appIconImageView = UIImageView(frame: rect)
        appIconImageView.contentMode = .scaleAspectFit
        appIconImageView.clipsToBounds = true
        appIconImageView.layer.cornerRadius = 5
        appIconImageView.layer.borderColor =
            UIColor(named: "LightSilver")?.cgColor
        appIconImageView.layer.borderWidth = 0.5
        appIconImageView.rx_setImage(by: urlString)
            .disposed(by: disposeBag)
        appIconImageView.isHidden = true
        appIconImageView.backgroundColor = UIColor.black
        appIconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
        }
        
        navigationController?.navigationItem.titleView = appIconImageView
    }
    
    //FIXME: 작업중
    func setNavigationBarButton() {
        //TODO: 네비게이션바 오른쪽에 다운로드 버튼 추가
        guard let result = searchResult else { return }
        var title = result.formattedPrice ?? "무료"
        title = title == "무료" ? "받기" : title
        
        let rect = CGRect(x: 0, y: 0, width: 70, height: 30)
        downloadButton = UIButton(frame: rect)
        downloadButton.setTitle(title, for: .normal)
        downloadButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        
        downloadButton.layer.cornerRadius = 30 / 2
        downloadButton.layer.borderColor =
            UIColor(named: "LightSilver")?.cgColor
        downloadButton.layer.borderWidth = 0.5
        
        let view = UIView(frame: rect)
        downloadButton.addSubview(view)
        let button = UIBarButtonItem(customView: view)
        navigationController?.navigationItem.rightBarButtonItem = button
    }
    
    func setDeatailTableView() {
        detailTableView.delegate = nil
        detailTableView.dataSource = nil
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.estimatedRowHeight = 100
    }
    
    func setAppMenu() {
        guard let result =  searchResult else { return }
        let factory = AppDetailFactory(result: result)
        
        appMenu = [
            factory.title(),
            factory.rating(),
            factory.screenShot(),
            factory.deviceInfo(),
            factory.description(),
            factory.developerInfo(),
            factory.infoTitle(),
            factory.seller(),
            factory.size(),
            factory.category(),
            factory.compatibility(),
            factory.language(),
            factory.age()
        ]
        
        //TODO: 업데이트 날짜가 3개월 이하일때 rating cell 아래에 미리보기 타이틀과 함께 적용
        //3개월 초과라면 developerInfo cell 아래에 적용
        if result.releaseNotes != nil {
            appMenu.insert(factory.feature(), at: 2)
            appMenu.insert(factory.preview(), at: 3)
        }
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
        let model = appMenu[index]
        
        switch model.type {
        case .feature:
            if let releaseNote = model as? ReleaseNote {
                releaseNote.needExtened = needExtened
                appMenu[index] = releaseNote
                dataSource.accept(appMenu)
            }
        case .description:
            if let description = model as? Description {
                description.needExtened = needExtened
                appMenu[index] = description
                dataSource.accept(appMenu)
            }
            
        case .info:
            if let info = model as? Info {
                info.needExtened = needExtened
                appMenu[index] = info
                dataSource.accept(appMenu)
            }
        default:
            break
        }
    }
    
    func makeCell(table: UITableView, index: Int, model: AppDetailProtocol) -> UITableViewCell {
        guard let factory = cellFactory else { return UITableViewCell() }
        
        switch model.type {
        case .title:
            return factory.appTitleCell(by: table, data: model, etcAction: self.etcAction)
        case .rating:
            return factory.appRatingCell(by: table, data: model)
        case .feature:
            return factory.newFeatureCell(by: table, data: model) { [weak self] (extened) in
                self?.readMore(with: index, needExtened: extened)
            }
        case .screenShot:
            return factory.screenShotCell(by: table, data: model)
        case .device:
            return factory.screenShotDeivceCell(by: table, data: model) { [weak self] (extened) in
                self?.readMore(with: index, needExtened: extened)
            }
        case .description:
            return factory.appDescriptionCell(by: table, data: model) { [weak self] (extened) in
                self?.readMore(with: index, needExtened: extened)
            }
        case .developerInfo:
            return factory.developerInfoCell(by: table, data: model)
        case .infoTitle:
            return factory.infoTitleCell(by: table, data: model)
        case .info:
            return factory.infoCell(by: table, data: model)
        }
    }
    
    func dataBinding() {
        dataSource.observeOn(MainScheduler.instance)
            .bind(to: detailTableView.rx.items) { [unowned self] table, index, model in
                return self.makeCell(table: table,
                                     index: index,
                                     model: model)
            }
        .disposed(by: disposeBag)
    }
    
    func selectCellItem() {
        detailTableView
            .rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] indexPath in
                if self.appMenu[indexPath.row].type == .developerInfo {
                    self.moveAppStoreOtherApp()
                } else {
                    self.readMore(with: indexPath.row, needExtened: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func showNaviItemIfNeed(with offset: CGPoint) {
        let index = IndexPath(row: 0, section: 0)
        let cell = detailTableView.cellForRow(at: index)
        if let height = cell?.frame.height {
            Log.verbose("cell height: \(height), offset.y: \(offset.y)")
            appIconImageView.isHidden = offset.y < height
        }
    }
    
    func tableViewDidScroll() {
        detailTableView
            .rx.contentOffset
            .asDriver()
            .drive(onNext: { [unowned self] contentOffset in
                self.showNaviItemIfNeed(with: contentOffset)
            })
            .disposed(by: disposeBag)
    }
}

class AppDetailViewController: UIViewController {

    
    @IBOutlet weak var detailTableView: UITableView!
    
    var searchResult: ResultElement?
    var cellFactory: AppDetailCellFactory?
    let disposeBag = DisposeBag()
    
    var appMenu = [AppDetailProtocol]()
    
    lazy var appIconImageView = UIImageView(image: nil)
    lazy var downloadButton = UIButton(frame: CGRect.zero)
    
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
        selectCellItem()
        
        setAppMenu()
        dataSource.accept(appMenu)
        
        //FIXME: 작업중
        setNavigationBarIcon()
        setNavigationBarButton()
        tableViewDidScroll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRrefersLargeTitles()
        navigationBarShadow(isHidden: true)
    }
}
