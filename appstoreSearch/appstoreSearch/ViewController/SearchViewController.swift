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
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "App Store"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func simpleAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(okAction)
        
        return alert
    }
    
    func errorAlert(_ error: Error) {
        let alert = simpleAlert(message: error.localizedDescription)
        
        present(alert, animated: true)
    }
    
    func search(by keyword: String) {
        API.shared.searchAppsotre(by: keyword)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .retry(2)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                Log.verbose("성공")
            }, onError: { [weak self] error in
                self?.errorAlert(error)
            }, onCompleted: {
                Log.verbose("onCompleted")
            })
            .disposed(by: disposeBag)
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
                let cell = self.searchHistoryTableView.cellForRow(at: indexPath) as? HistoryCell
                Log.verbose(cell?.titleLabel.text ?? "")
                cell?.setSelected(false, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}

//- MARK: SearchBar
extension SearchViewController {
    
    func removeJamo(to text: String) -> String {
        let jamo: [Character] = [
            "ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ",
            "ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ",
            
            "ㄳ","ㄵ","ㄶ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅄ",
            
            "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ","ㅕ", "ㅖ", "ㅗ", "ㅘ",
            "ㅙ", "ㅚ","ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ",
            "ㅣ"
        ]
        
        var result: String = ""
        for case let unit in Array(text) where !jamo.contains(unit) {
            result.append(unit)
        }
        
        return result
    }
    
    func saveSearchText(_ text: String) {
        guard !text.isEmpty else { return }
        guard text.isHangul() else { return }
        SearchHistory.insert(text)
        dataSource.accept(SearchHistory.get())
    }
    
    func hangulWarningAlert() {
        let alert = simpleAlert(message: "한글만 입력 가능합니다.")
        present(alert, animated: true) { [weak self] in
            self?.searchController.searchBar.text = ""
        }
    }
    
    func isHangul(_ searchText: String) -> Bool {
        let hangul = searchText.isHangul()
        if !hangul {
            hangulWarningAlert()
        }
        
        return hangul
    }
    
    func searchBarEditing() {
        searchController.searchBar
            .rx.text
            .orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { [unowned self] text in
                self.searchController.isActive && self.isHangul(text)
            }
            .bind { [unowned self] searchText in
                Log.debug(searchText)
                self.navigationBarShadow(isHidden: searchText.isEmpty)
            }
            .disposed(by: disposeBag)
    }
    
    func searchBarEndEditing() {
        searchController.searchBar
            .rx.textDidEndEditing
            .asDriver()
            .drive(onNext: { [unowned self] in
                Log.verbose("Enter")
                let text = self.searchController.searchBar.text ?? ""
                self.saveSearchText(text)
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
            })
            .disposed(by: disposeBag)
    }
}


//TODO: 검색시 연관검색어 대신 히스토리에서 검색하여 표시
//TODO: 검색 결과 화면은 스크린샷과 동일하게 구현
//TODO: 상세 화면은 제공되는 API내에서 최대한 구현

class SearchViewController: UIViewController {

    @IBOutlet weak var searchHistoryTableView: UITableView!
    @IBOutlet weak var searchHistoryTitleView: UIView!
    @IBOutlet weak var searchHistoryTitleLabel: UILabel!
    
    let disposeBag = DisposeBag()
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    var dataSource = BehaviorRelay(value: SearchHistory.get())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarShadow(isHidden: true)
        setSearchHistoryTableView()
        setSearchController()
        
        dataBinding()
        selectCellItem()
        
        searchBarEditing()
        searchBarEndEditing()
        searchBarCancel()
    }
}

