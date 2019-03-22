//
//  ResultTypeController.swift
//  appstoreSearch
//
//  Created by Elon on 19/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import SnapKit

enum ResultType {
    case related
    case result
}

class ResultTypeController: UIViewController {
    var selectItem: (Any) -> Void = { _ in }
    
    func add(to parent: UIViewController) {
        parent.addChild(self)
        parent.view.addSubview(self.view)
        self.view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        self.didMove(toParent: parent)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
