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
    }
    
    func dataBinding() {
        dataSource
            .asDriver()
            .drive(detailTableView.rx.items(
                cellIdentifier: AppTitleCell.identifier,
                cellType: AppTitleCell.self)) { row, model, cell in
                    cell.setUI(with: model)
            }
            .disposed(by: disposeBag)
    }
}

class AppDetailViewController: UIViewController {

    
    @IBOutlet weak var detailTableView: UITableView!
    
    var searchResult: ResultElement?
    let disposeBag = DisposeBag()
    
    ///FIXME: 임시 데이터
    var dataSource = BehaviorRelay(value: [ResultElement]())
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRrefersLargeTitles()
        navigationBarShadow(isHidden: true)
    }
}
