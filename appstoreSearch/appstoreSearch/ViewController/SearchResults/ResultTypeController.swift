//
//  ResultTypeController.swift
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

class ResultTypeController: UIViewController {
    var selectItem: (Any) -> Void = { _ in }
    
    func add(to parent: UIViewController) {
        parent.addChild(self)
        parent.view.addSubview(self.view)
        self.view.autoresizingMask = [ .flexibleWidth, .flexibleWidth ]
        self.didMove(toParent: parent)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
