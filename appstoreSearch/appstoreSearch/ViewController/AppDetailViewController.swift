//
//  AppDetailViewController.swift
//  appstoreSearch
//
//  Created by Elon on 20/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit

class AppDetailViewController: UIViewController {

    class func instantiateVC() -> AppDetailViewController {
        let identifier = "AppDetailViewController"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let appDetailVC = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return appDetailVC as! AppDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
