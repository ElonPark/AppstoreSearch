//
//  UIImageViewExtension.swift
//  appstoreSearch
//
//  Created by Elon on 20/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension UIImageView {
    
    func rx_setImage(by urlString: String) -> Disposable {
        return API.shared.requestImage(urlString: urlString)
            .retry(2)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] imageData in
                self?.image = UIImage(data: imageData)
                }, onError: { error in
                    Log.error(error.localizedDescription, error)
            })
    }
}
