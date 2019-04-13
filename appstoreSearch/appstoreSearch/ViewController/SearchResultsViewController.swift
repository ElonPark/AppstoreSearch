//
//  SearchResultsViewController.swift
//  appstoreSearch
//
//  Created by Elon on 19/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit


final class SearchResultsViewController: UIViewController {

    var currentVC: ResultTypeController?
    
    weak var relatedKeywordsVC: RelatedKeywordsViewController?
    weak var appResultsVC: AppResultsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func change(vc: ResultTypeController?) {
        currentVC?.remove()
        currentVC = nil
        vc?.add(to: self)
        currentVC = vc
    }
    
    func result(type: ResultType, with searchText: String) {
        Log.verbose(type)
        switch type {
        case .related:
            if relatedKeywordsVC == nil {
                relatedKeywordsVC = instantiateVC(by: .main)
            }
            change(vc: relatedKeywordsVC)
            relatedKeywordsVC?.rx_searchText.accept(searchText)
            
        case .result:
            if appResultsVC == nil {
                appResultsVC = instantiateVC(by: .main)
            }
            change(vc: appResultsVC)
            appResultsVC?.dataSource.accept([])
            appResultsVC?.rx_searchText.accept(searchText)
        }
    }
}
