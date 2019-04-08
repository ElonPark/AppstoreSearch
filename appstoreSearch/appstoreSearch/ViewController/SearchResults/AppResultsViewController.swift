//
//  AppResultsViewController.swift
//  appstoreSearch
//
//  Created by Elon on 18/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class AppResultsViewController: ResultTypeController {

    @IBOutlet weak var resultEmptyView: UIView!
    @IBOutlet weak var resultEmptyLabel: UILabel!
    @IBOutlet weak var searchTextLabel: UILabel!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    var searchResult: Result?
    let rx_searchText = BehaviorRelay(value: String())
    let dataSource = BehaviorRelay(value: [ResultElement]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchResultTableView()
        searchText()
        dataBinding()
        selectCellItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension AppResultsViewController {
    
    private func errorAlert(_ error: Error) {
        let alert = UIAlertController(title: "",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
   private func setSearchResultTableView() {
        searchResultTableView.delegate = nil
        searchResultTableView.dataSource = nil
        
        searchResultTableView.rowHeight = UITableView.automaticDimension
        searchResultTableView.estimatedRowHeight = 310
    }
    
    private func setResultEmptyView(with searchText: String) {
        searchTextLabel.text = "'\(searchText)'"
    }
    
    private func updateDataSource(by result: Result) {
        searchResult = result
        dataSource.accept(result.results)
    }
    
    private func showResultEmptyView() {
        searchResult = nil
        searchResultTableView.isHidden = true
    }
    
    private func checkResultCount() {
        guard let result = searchResult else { return }
        searchResultTableView.isHidden = result.resultCount < 1
    }
    
    private func search(by keyword: String) {
        API.shared.searchAppsotre(by: keyword.removeJamo())
            .retry(2)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.updateDataSource(by: result)
                }, onError: { [weak self] error in
                    Log.error(error.localizedDescription, error)
                    self?.showResultEmptyView()
                }, onCompleted: { [weak self] in
                    self?.checkResultCount()
            })
            .disposed(by: disposeBag)
    }
    
    private func searchText() {
        rx_searchText
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [unowned self] text in
                self.setResultEmptyView(with: text)
                self.dataSource.accept([])
                self.search(by: text)
            }
            .disposed(by: disposeBag)
    }
}

extension AppResultsViewController {
    private func dataBinding() {
        dataSource
            .asDriver()
            .drive(searchResultTableView.rx.items(
                cellIdentifier: SearchResultCell.identifier,
                cellType: SearchResultCell.self)) { row, model, cell in
                    cell.setUI(with: model)
            }
            .disposed(by: disposeBag)
    }
    
    private func selectCellItem() {
        searchResultTableView
            .rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] indexPath in
                let result = self.dataSource.value[indexPath.row]
                self.selectItem(result)
                self.searchResultTableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
    }
}
