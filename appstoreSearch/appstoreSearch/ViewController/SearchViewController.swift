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


final class SearchViewController: UIViewController {

    @IBOutlet weak var searchHistoryTableView: UITableView!
    @IBOutlet weak var searchHistoryTitleView: UIView!
    @IBOutlet weak var searchHistoryTitleLabel: UILabel!

    private let disposeBag = DisposeBag()
    
    private lazy var searchResultsVC = SearchResultsViewController()
    private lazy var searchController = UISearchController(searchResultsController: searchResultsVC)
    
    private var dataSource = BehaviorRelay(value: SearchHistory.get())
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRrefersLargeTitles()
        navigationBarShadow(isHidden: !searchController.isActive)
    }
}

extension SearchViewController {
    
    private func setRrefersLargeTitles() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.prefersLargeTitles = true
    }
    
    private func navigationBarShadow(isHidden: Bool) {
        navigationController?.navigationBar.setValue(isHidden, forKey: "hidesShadow")
    }
    
    private func setSearchHistoryTableView() {
        searchHistoryTableView.delegate = nil
        searchHistoryTableView.dataSource = nil
    }
    
    private func setSearchController() {
        searchController.searchBar.placeholder = "App Store"
        searchController.searchBar.setValue("취소", forKey: "_cancelButtonText")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func moveAppDetailVC(with model: ResultElement) {
        guard let appDetailVC: AppDetailViewController = instantiateVC(by: .main) else { return }
        appDetailVC.searchResult = model
        appDetailVC.cellFactory = AppDetailCellFactory(result: model)
        
        navigationController?.pushViewController(appDetailVC,
                                                 animated: true)
    }
    
    private func relatedResultSelect() {
        searchResultsVC.relatedKeywordsVC?.selectItem = { [weak self] result in
            guard let text = result as? String else { return }
            Log.verbose(text)
            self?.setSearchBar(text: text)
            self?.setResult(by: text, type: .result)
        }
    }
    
    private func searchResultSelect() {
        searchResultsVC.appResultsVC?.selectItem = { [weak self] result in
            guard let element = result as? ResultElement else { return }
            Log.verbose(element.trackName)
            self?.moveAppDetailVC(with: element)
        }
    }
    
    private func setSearchBar(text: String) {
        searchController.searchBar.text = text
        searchController.isActive = true
        searchController.searchBar.resignFirstResponder()
    }
    
    private func setResult(by searchText: String, type: ResultType) {
        searchResultsVC.result(type: type, with: searchText)
        relatedResultSelect()
        searchResultSelect()
    }
    
    private func search(by index: IndexPath) {
        let text = dataSource.value[index.row]
    
        navigationBarShadow(isHidden: false)
        setSearchBar(text: text)
        saveSearchText(text)
        setResult(by: text, type: .result)
        
        Log.verbose(text)
    }
}


//- MARK: TableView
extension SearchViewController {
    
    private func dataBinding() {
        dataSource
            .asDriver()
            .drive(searchHistoryTableView.rx.items(
                cellIdentifier: HistoryCell.identifier,
                cellType: HistoryCell.self)) { row, model, cell in
                    cell.titleLabel.text = model
            }
            .disposed(by: disposeBag)
    }
    
    private func selectCellItem() {
        searchHistoryTableView
            .rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] indexPath in
                self.search(by: indexPath)
                self.searchHistoryTableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
    }
}


//- MARK: SearchBar
extension SearchViewController {
    
    private func saveSearchText(_ text: String) {
        guard !text.isEmpty else { return }
        guard text.isHangul() else { return }
        SearchHistory.insert(text)
        dataSource.accept(SearchHistory.get())
    }
    
    private func hangulWarningAlert() {
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
    
    private func isHangul(_ searchText: String) -> Bool {
        let hangul = searchText.isEmpty ? true : searchText.isHangul()
        if !hangul {
            hangulWarningAlert()
        }
        
        return hangul
    }
    
    private func searchBarEditing() {
        searchController.searchBar
            .rx.text
            .orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
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
    
    private func searchButtonClicked() {
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
    
    private func searchBarCancel() {
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
