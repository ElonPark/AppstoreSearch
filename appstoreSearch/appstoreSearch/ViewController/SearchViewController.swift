//
//  SearchViewController.swift
//  appstoreSearch
//
//  Created by Elon on 16/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension SearchViewController {
    
    func navigationBarShadow(isHidden: Bool) {
        navigationController?.navigationBar.setValue(isHidden, forKey: "hidesShadow")
    }
    
    func setSearchHistoryTableView() {
        searchHistoryTableView.delegate = nil
        searchHistoryTableView.dataSource = nil
    }
    
    func setSearchController() {
        searchController.searchBar.placeholder = "App Store"
        searchController.searchBar.setValue("취소", forKey: "_cancelButtonText")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func setResult(by searchText: String, type: ResultType) {
        searchResultsVC.result(type: type, with: searchText)
    }
    
    func setSearchBar(text: String) {
        searchController.searchBar.text = text
        searchController.isActive = true
        searchController.searchBar.resignFirstResponder()
    }
    
    func relatedResultSelect() {
        searchResultsVC.relatedKeywordsVC.selectItem = { [weak self] result in
            guard let text = result as? String else { return }
            Log.verbose(text)
            self?.setSearchBar(text: text)
            self?.setResult(by: text, type: .result)
        }
    }
    
    func searchResultSelect() {
        searchResultsVC.appResultsVC.selectItem = { result in
            guard let element = result as? ResultElement else { return }
            Log.verbose(element.trackName)
        }
    }
 
    func search(by index: IndexPath) {
        let cell = searchHistoryTableView.cellForRow(at: index) as? HistoryCell
        cell?.setSelected(false, animated: true)
        
        let text = cell?.titleLabel.text ?? ""
        navigationBarShadow(isHidden: false)
        setSearchBar(text: text)
        setResult(by: text, type: .result)
        Log.verbose(text)
    }
}

//- MARK: TableView
extension SearchViewController {
    
    func dataBinding() {
        dataSource
            .asDriver()
            .drive(searchHistoryTableView.rx.items(
                cellIdentifier: HistoryCell.identifier,
                cellType: HistoryCell.self)) { row, model, cell in
                    cell.titleLabel.text = model
            }
            .disposed(by: disposeBag)
    }
    
    func selectCellItem() {
        searchHistoryTableView
            .rx.itemSelected
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [unowned self] indexPath in
                self.search(by: indexPath)
            }
            .disposed(by: disposeBag)
    }
}

//- MARK: SearchBar
extension SearchViewController {
    
    func saveSearchText(_ text: String) {
        guard !text.isEmpty else { return }
        guard text.isHangul() else { return }
        SearchHistory.insert(text)
        dataSource.accept(SearchHistory.get())
    }
    
    func hangulWarningAlert() {
        let alert = UIAlertController(title: "",
                                      message: "한글만 입력 가능합니다.",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .cancel) { [weak self] _ in
            self?.searchController.searchBar.becomeFirstResponder()
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true) { [weak self] in
            self?.searchController.searchBar.text = ""
        }
    }
    
    func isHangul(_ searchText: String) -> Bool {
        let hangul = searchText.isEmpty ? true : searchText.isHangul()
        if !hangul {
            hangulWarningAlert()
        }
        
        return hangul
    }
 
    func searchBarEditing() {
        searchController.searchBar
            .rx.text
            .orEmpty
            .throttle(0.3, latest: true, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { [unowned self] text in
                self.searchController.isActive && self.isHangul(text)
            }
            .bind { [unowned self] searchText in
                self.navigationBarShadow(isHidden: searchText.isEmpty)
                
                Log.debug(searchText)
                self.setResult(by: searchText, type: .related)
            }
            .disposed(by: disposeBag)
    }
    
    func searchButtonClicked() {
        searchController.searchBar
            .rx.searchButtonClicked
            .asDriver()
            .drive(onNext: { [unowned self] in
                Log.verbose("Enter")
                let text = self.searchController.searchBar.text ?? ""
                self.saveSearchText(text)
                self.setResult(by: text, type: .result)
            })
            .disposed(by: disposeBag)
    }
    
    func searchBarCancel() {
        searchController.searchBar
            .rx.cancelButtonClicked
            .asDriver()
            .drive(onNext: { [unowned self] in
                Log.verbose("Cancel")
                self.navigationBarShadow(isHidden: true)
                self.searchController.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}


//TODO: 검색 결과 화면은 스크린샷과 동일하게 구현
//TODO: 상세 화면은 제공되는 API내에서 최대한 구현

class SearchViewController: UIViewController {

    @IBOutlet weak var searchHistoryTableView: UITableView!
    @IBOutlet weak var searchHistoryTitleView: UIView!
    @IBOutlet weak var searchHistoryTitleLabel: UILabel!

    let disposeBag = DisposeBag()
    
    lazy var searchResultsVC = SearchResultsViewController()
    lazy var searchController = UISearchController(searchResultsController: searchResultsVC)
    
    var dataSource = BehaviorRelay(value: SearchHistory.get())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationBarShadow(isHidden: true)
        setSearchHistoryTableView()
        setSearchController()
        
        dataBinding()
        selectCellItem()
        
        searchBarEditing()
        searchButtonClicked()
        searchBarCancel()
        
        relatedResultSelect()
        searchResultSelect()
    }
}

