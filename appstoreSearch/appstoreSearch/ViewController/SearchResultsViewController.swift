//
//  SearchResultsViewController.swift
//  appstoreSearch
//
//  Created by Elon on 19/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit


class SearchResultsViewController: UIViewController {

    var currentVC: ResultTypeController?
    
    lazy var relatedKeywordsVC: RelatedKeywordsViewController? = instantiateVC(by: .main)
    lazy var appResultsVC: AppResultsViewController? = instantiateVC(by: .main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    private func change(vc: ResultTypeController?) {
        currentVC?.remove()
        vc?.add(to: self)
        currentVC = vc
        
    }
    
    func result(type: ResultType, with searchText: String) {
        Log.verbose(type)
        switch type {
        case .related:
            change(vc: relatedKeywordsVC)
            relatedKeywordsVC?.rx_searchText.accept(searchText)
            
        case .result:
            change(vc: appResultsVC)
            appResultsVC?.rx_searchText.accept(searchText)
        }
    }
}
