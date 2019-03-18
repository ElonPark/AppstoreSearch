//
//  SearchResultViewController.swift
//  appstoreSearch
//
//  Created by Elon on 18/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension SearchResultViewController {
    
    func setSearchResultTableView() {
        searchResultTableView.delegate = nil
        searchResultTableView.dataSource = nil
    }
    
    func errorAlert(_ error: Error) {
        let alert = UIAlertController(title: "",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func setResultEmptyView(with searchText: String) {
        searchTextLabel.text = "'\(searchText)'"
    }
    
    func updateDataSource(by result: Result) {
        searchResultTableView.isHidden = result.resultCount > 0
        dataSource.accept(result.results)
    }
    
    func search(by keyword: String) {
        API.shared.searchAppsotre(by: keyword.removeJamo())
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .retry(2)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                Log.verbose("성공")
                self?.updateDataSource(by: result)
            }, onError: { [weak self] error in
                self?.errorAlert(error)
                }, onCompleted: {
                    Log.verbose("onCompleted")
            })
            .disposed(by: disposeBag)
    }
    
    func searchText() {
        rx_searchText
            .asDriver()
            .drive(onNext: { [unowned self] text in
                self.setResultEmptyView(with: text)
                self.search(by: text)
            })
            .disposed(by: disposeBag)
    }
    
    func dataBinding() {
        dataSource
            .asDriver()
            .drive(searchResultTableView.rx.items(
                cellIdentifier: SearchResultCell.identifier,
                cellType: SearchResultCell.self)) { row, model, cell in
                    Log.verbose(model.trackName)
                    cell.setUI(with: model)
                    cell.rx_downlaod()
            }
            .disposed(by: disposeBag)
    }
    
    func selectCellItem() {
        searchResultTableView
            .rx.itemSelected
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [unowned self] indexPath in
                let cell = self.searchResultTableView.cellForRow(at: indexPath) as? SearchResultCell
                Log.verbose(cell?.titleLabel.text ?? "")
            }
            .disposed(by: disposeBag)
    }
    
}

class SearchResultViewController: UIViewController {

    
    @IBOutlet weak var resultEmptyView: UIView!
    @IBOutlet weak var resultEmptyLabel: UILabel!
    @IBOutlet weak var searchTextLabel: UILabel!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    

    let disposeBag = DisposeBag()
    let rx_searchText = BehaviorRelay(value: String())
    let dataSource = BehaviorRelay(value: [ResultElement]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchResultTableView()
        searchText()
        dataBinding()
        selectCellItem()
    }
}
