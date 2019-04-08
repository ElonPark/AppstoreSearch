//
//  RelatedKeywordsViewController.swift
//  appstoreSearch
//
//  Created by Elon on 17/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class RelatedKeywordsViewController: ResultTypeController {

    @IBOutlet weak var relatedResultTableView: UITableView!
    @IBOutlet weak var tableViewHaderSpaceView: UIView!
    
    private let disposeBag = DisposeBag()
    
    var relatedResults = [String]()
    lazy var rx_searchText = BehaviorRelay(value: String())
    lazy var dataSource = BehaviorRelay(value: relatedResults)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRelatedResultTableView()
        
        dataBinding()
        searchText()
        selectCellItem()
    }
}

extension RelatedKeywordsViewController {
    
    private func setRelatedResultTableView() {
        relatedResultTableView.delegate = nil
        relatedResultTableView.dataSource = nil
    }
    
    private func searchText() {
        rx_searchText
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind { [unowned self] text in
                let history = SearchHistory.get()
                self.relatedResults = history.filter {
                    $0.hasCaseInsensitivePrefix(text)
                }
                self.dataSource.accept(self.relatedResults)
            }
            .disposed(by: disposeBag)
    }
    
    private func dataBinding() {
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
    
    private func selectCellItem() {
        relatedResultTableView
            .rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] indexPath in
                let text = self.dataSource.value[indexPath.row]
                self.selectItem(text)
                self.relatedResultTableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
    }
}
