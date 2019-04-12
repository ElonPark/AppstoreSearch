//
//  Instantiate.swift
//  appstoreSearch
//
//  Created by Elon on 08/04/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit

enum AppStoryboard: String {
    case main = "Main"
}

extension UIViewController {
    func instantiateVC<T: UIViewController>(by storyboardName: AppStoryboard) -> T? {
        let type = String(describing: T.Type.self)
        guard let identifier = type.components(separatedBy: ".").first else { return nil }
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return vc as? T
    }
}
