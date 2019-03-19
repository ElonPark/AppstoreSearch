//
//  ResultsViewController.swift
//  appstoreSearch
//
//  Created by Elon on 19/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit

enum ResultType {
    case related
    case result
}

class ResultsViewController: UIViewController {

    var currentVC: ResultTypeController?
    
    lazy var relatedResultVC = RelatedResultViewController.instantiateVC()
    lazy var searchResultVC = SearchResultViewController.instantiateVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    private func change(vc: ResultTypeController) {
        currentVC?.remove()
        vc.add(to: self)
        currentVC = vc
    }
    
    func result(type: ResultType, with searchText: String) {
        Log.verbose(type)
        switch type {
        case .related:
            change(vc: relatedResultVC)
            relatedResultVC.rx_searchText.accept(searchText)
            
        case .result:
            change(vc: searchResultVC)
            searchResultVC.rx_searchText.accept(searchText)
        }
    }
}
