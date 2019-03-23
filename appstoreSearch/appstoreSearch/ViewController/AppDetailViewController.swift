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
    
    func setNavigationBarIcon() {
        guard let urlString = searchResult?.artworkURL60 else { return }
        appIconImageView.rx_setImage(by: urlString)
            .disposed(by: disposeBag)
        
        navigationItem.titleView = appIconImageView
    }
    
    func setNavigationBarButton() {
        guard let result = searchResult else { return }
        var title = result.formattedPrice ?? "무료"
        title = title == "무료" ? "받기" : title
        
        let attributedString = title.attribute(size: 14,
                                               weight: .semibold,
                                               color: UIColor.white)
        
        downloadButton.setAttributedTitle(attributedString, for: .normal)
        
        let barButtonItem = UIBarButtonItem(customView: downloadButton)
        navigationItem.rightBarButtonItem = barButtonItem
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
            factory.age(),
            factory.developerSite()
        ]
        
        //TODO: 업데이트 날짜가 3개월 이하일때 rating cell 아래에 미리보기 타이틀과 함께 적용
        //3개월 초과라면 developerInfo cell 아래에 적용
        if result.releaseNotes != nil {
            appMenu.insert(factory.feature(), at: 2)
            appMenu.insert(factory.preview(), at: 3)
        }
    }
    
    
    func showShareSheet() {
        guard let urlString = searchResult?.trackViewURL,
            let url = URL(string: urlString) else {
                return
        }
        
        let items: [Any] = [url, urlString]
        let activityVC = UIActivityViewController(activityItems: items,
                                                  applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    func moveOutside(to urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    func moveAppstoreAppPage() {
        guard let urlString = self.searchResult?.trackViewURL else { return }
        moveOutside(to: urlString)
    }
    
    func moveAppStoreOtherApp() {
        guard let artistID = searchResult?.artistID else { return }
        let appStoreURLString = "itms-apps://itunes.apple.com/developer/id\(artistID)"
        moveOutside(to: appStoreURLString)
    }
 
    func moveDeveloperSite() {
        guard let urlString = searchResult?.sellerURL else { return }
        
        moveOutside(to: urlString)
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
            guard let releaseNote = model as? ReleaseNote  else { return }
            guard !releaseNote.needExtened else { return }
            releaseNote.needExtened = needExtened
            appMenu[index] = releaseNote
            dataSource.accept(appMenu)
            
        case .description:
            guard let description = model as? Description else { return }
            guard !description.needExtened else { return }
            description.needExtened = needExtened
            appMenu[index] = description
            dataSource.accept(appMenu)
            
        case .info:
            guard let info = model as? Info else { return }
            guard !info.needExtened else { return }
            info.needExtened = needExtened
            appMenu[index] = info
            dataSource.accept(appMenu)
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
            
        case .developerSite:
            return factory.developerSite(by: table, data: model)
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
    
    func selectItem(by indexPath: IndexPath) {
        switch appMenu[indexPath.row].type {
        case .developerInfo:
            moveAppStoreOtherApp()
        case .developerSite:
            moveDeveloperSite()
        default:
            readMore(with: indexPath.row, needExtened: true)
        }
    }
    
    func selectCellItem() {
        detailTableView
            .rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] indexPath in
                self.selectItem(by: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    func tapDownloadButton() {
        downloadButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.moveAppstoreAppPage()
            })
            .disposed(by: disposeBag)
    }
    
    func showNaviItemIfNeed(with offset: CGPoint) {
        let index = IndexPath(row: 0, section: 0)
        let cell = detailTableView.cellForRow(at: index)
        if let height = cell?.frame.height {
            appIconImageView.isHidden = offset.y < height
            downloadButton.isHidden = offset.y < height
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
    
    lazy var appIconImageView: UIImageView  = {
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let imageView = UIImageView(frame: rect)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor =
            UIColor(named: "LightSilver")?.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.isHidden = true
        
        return imageView
    }()
    
   lazy var downloadButton: UIButton = {
        let rect = CGRect(x: 0, y: 0, width: 70, height: 30)
        let button = UIButton(frame: rect)
        button.backgroundColor = button.tintColor
        
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        
        button.layer.cornerRadius = 30 / 2
        button.layer.borderColor =
            UIColor(named: "LightSilver")?.cgColor
        button.layer.borderWidth = 0.5
        button.isHidden = true
    
        return button
    }()
    
    lazy var dataSource = BehaviorRelay(value: appMenu)
    
    class func instantiateVC() -> AppDetailViewController {
        let identifier = "AppDetailViewController"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let appDetailVC = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return appDetailVC as! AppDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarIcon()
        setNavigationBarButton()
        
        setDeatailTableView()
        tableViewDidScroll()
        dataBinding()
        selectCellItem()
        tapDownloadButton()
        
        setAppMenu()
        dataSource.accept(appMenu)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRrefersLargeTitles()
        navigationBarShadow(isHidden: true)
    }
}
