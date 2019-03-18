//
//  RelatedResultViewController.swift
//  appstoreSearch
//
//  Created by Elon on 17/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension RelatedResultViewController {
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    func setRelatedResultTableView() {
        relatedResultTableView.delegate = nil
        relatedResultTableView.dataSource = nil
    }
    
    func searchText() {
        rx_searchText
            .asDriver()
            .drive(onNext: { [unowned self] text in
                let history = SearchHistory.get()
                self.relatedResults = history.filter {
                    $0.hasCaseInsensitivePrefix(text)
                }
                self.dataSource.accept(self.relatedResults)
            })
            .disposed(by: disposeBag)
    }
    
    func dataBinding() {
        dataSource
            .asDriver()
            .drive(relatedResultTableView.rx.items(
                cellIdentifier: RelatedResultCell.identifier,
                cellType: RelatedResultCell.self)) { [unowned self] row, model, cell in
                    let searchText = self.rx_searchText.value
                    cell.setTitle(text: model, with: searchText)
            }
            .disposed(by: disposeBag)
    }
    
    func selectCellItem() {
        relatedResultTableView
            .rx.itemSelected
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [unowned self] indexPath in
                let cell = self.relatedResultTableView.cellForRow(at: indexPath) as? RelatedResultCell
                Log.verbose(cell?.titleLabel.text ?? "")
                cell?.setSelected(false, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

class RelatedResultViewController: UIViewController {

    @IBOutlet weak var relatedResultTableView: UITableView!
    @IBOutlet weak var tableViewHaderSpaceView: UIView!
    
    let disposeBag = DisposeBag()
    
    var relatedResults = [String]()
    lazy var rx_searchText = BehaviorRelay(value: String())
    lazy var dataSource = BehaviorRelay(value: relatedResults)
    static let seguIdentifier = "RelatedResult"
    
    class func instantiateVC() -> RelatedResultViewController {
        let identifier = "RelatedResultViewController"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let relatedResultVC = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return relatedResultVC as! RelatedResultViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRelatedResultTableView()
        
        dataBinding()
        searchText()
        selectCellItem()
    }
}
