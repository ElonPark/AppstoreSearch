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


extension AppResultsViewController {
    
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
                self.searchResult = nil
                self.dataSource.accept([ResultElement]())
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
            .asDriver()
            .drive(onNext: { [unowned self] indexPath in
                let result = self.dataSource.value[indexPath.row]
                self.selectItem(result)
                let cell = self.searchResultTableView.cellForRow(at: indexPath) as? SearchResultCell
                cell?.setSelected(false, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

class AppResultsViewController: ResultTypeController {

    @IBOutlet weak var resultEmptyView: UIView!
    @IBOutlet weak var resultEmptyLabel: UILabel!
    @IBOutlet weak var searchTextLabel: UILabel!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var searchResult: Result?
    let rx_searchText = BehaviorRelay(value: String())
    let dataSource = BehaviorRelay(value: [ResultElement]())
    
    
    class func instantiateVC() -> AppResultsViewController {
        let identifier = "AppResultsViewController"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let appResultsVC = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return appResultsVC as! AppResultsViewController
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
        resultEmptyView.isHidden = true
    }
}
