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

        searchResultTableView.rowHeight = UITableView.automaticDimension
        searchResultTableView.estimatedRowHeight = 310
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
        searchResult = result
        dataSource.accept(result.results)
    }
    
    func showResultEmptyViewIfNeeded() {
        let resultCount = searchResult?.resultCount ?? 0
        searchResultTableView.isHidden = resultCount < 1
        resultEmptyView.isHidden = resultCount > 0
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
                Log.error(error.localizedDescription, error)
                self?.searchResult = nil
                self?.showResultEmptyViewIfNeeded()
                }, onCompleted: { [weak self] in
                    Log.verbose("onCompleted")
                    self?.showResultEmptyViewIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    func searchText() {
        rx_searchText
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind { [unowned self] text in
                self.setResultEmptyView(with: text)
                self.search(by: text)
            }
            .disposed(by: disposeBag)
    }
    
    func dataBinding() {
        dataSource
            .asDriver()
            .drive(searchResultTableView.rx.items(
                cellIdentifier: SearchResultCell.identifier,
                cellType: SearchResultCell.self)) { row, model, cell in
                    cell.setUI(with: model)
            }
            .disposed(by: disposeBag)
    }
    
    func selectCellItem() {
        searchResultTableView
            .rx.itemSelected
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [unowned self] indexPath in
                let result = self.dataSource.value[indexPath.row]
                self.selectItem(result)
            }
            .disposed(by: disposeBag)
    }
}

class SearchResultViewController: ResultTypeController {

    @IBOutlet weak var resultEmptyView: UIView!
    @IBOutlet weak var resultEmptyLabel: UILabel!
    @IBOutlet weak var searchTextLabel: UILabel!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var searchResult: Result?
    let disposeBag = DisposeBag()
    let rx_searchText = BehaviorRelay(value: String())
    let dataSource = BehaviorRelay(value: [ResultElement]())
    
    
    class func instantiateVC() -> SearchResultViewController {
        let identifier = "SearchResultViewController"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let relatedResultVC = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return relatedResultVC as! SearchResultViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchResultTableView()
        searchText()
        dataBinding()
        selectCellItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultTableView.isHidden = false
    }
}
