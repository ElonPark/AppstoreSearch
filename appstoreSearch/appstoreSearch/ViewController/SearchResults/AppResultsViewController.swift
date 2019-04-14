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


final class AppResultsViewController: ResultTypeController {

    @IBOutlet weak var resultEmptyView: UIView!
    @IBOutlet weak var resultEmptyLabel: UILabel!
    @IBOutlet weak var searchTextLabel: UILabel!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    var searchResult: Result?
    private let cellHeight: CGFloat = 305
    let rx_searchText = BehaviorRelay(value: String())
    let dataSource = BehaviorRelay(value: [AppResult]())
    
    deinit {
        Log.verbose("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchResultTableView()
        
        searchText()
        dataBinding()
        selectCellItem()
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
        searchResultTableView.estimatedRowHeight = cellHeight
    }
    
    private func setResultEmptyView(with searchText: String) {
        searchTextLabel.text = "'\(searchText)'"
    }
    
    private func showResultEmptyView() {
        searchResult = nil
        searchResultTableView.isHidden = true
    }
    
    private func checkResultCount(by result: Result) {
        Log.verbose(result.resultCount)
        guard result.resultCount < 1 else { return }
        showResultEmptyView()
    }
    
    private func requestImages(by model: ResultElement) -> [Observable<Data>] {
        let iconURLString = model.artworkURL100
        var requests = [API.shared.requestImage(urlString: iconURLString)]
        
        for i in 0..<model.screenshotURLs.count {
            guard i < 3 else { break }
            guard let urlString = model.screenshotURLs[safe: i] else { continue }
            requests.append(API.shared.requestImage(urlString: urlString))
        }
        
        return requests
    }
    
    private func rx_appResult(by element: ResultElement) -> Observable<AppResult> {
        
        let imageRequests = requestImages(by: element)
        
        return Observable.concat(imageRequests)
            .map { UIImage(data: $0) }
            .reduce([UIImage?]()) { images, image in
                var appImages = images
                appImages.append(image)
                return appImages
            }
            .map { images in
                var appImages = images
                var result = AppResult(element)
                result.iconImage = appImages.removeFirst()
                result.screenshots = appImages
                return result
        }
    }

    private func updateDataSource(by result: Result) {
        searchResult = result
        guard result.resultCount > 0 else { return }
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .utility)
        
        Observable.from(result.results)
            .subscribeOn(scheduler)
            .flatMap { self.rx_appResult(by: $0) }
            .reduce([AppResult]()) { results, datum in
                var appResults = results
                appResults.append(datum)
                return appResults
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { appResults in
                self.dataSource.accept(appResults)
                }, onError: { error in
                    Log.error(error.localizedDescription, error)
            })
            .disposed(by: disposeBag)
    }
    
    private func search(by keyword: String) {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .utility)
        
        API.shared.searchAppsotre(by: keyword.removeJamo())
            .retry(2)
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { searchResult in
                self.checkResultCount(by: searchResult)
                self.updateDataSource(by: searchResult)
            }, onError: { error in
                Log.error(error.localizedDescription, error)
                self.showResultEmptyView()
            })
            .disposed(by: disposeBag)
    }
    
    private func searchText() {
        rx_searchText
            .filter { !$0.isEmpty }
            .bind { [weak self] text in
                self?.setResultEmptyView(with: text)
                self?.search(by: text)
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
                let result = self.dataSource.value[indexPath.row].appData
                self.selectItem(result)
                self.searchResultTableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
    }
}
