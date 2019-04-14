//
//  ScreenShotCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class ScreenShotCell: UITableViewCell {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    static let identifier: String = "ScreenShotCell"
    
    lazy var dataSource = BehaviorRelay(value: [UIImage?]())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCollectionView.dataSource = nil
        imageCollectionView.delegate = nil
        dataBinding()
        
    }
}

extension ScreenShotCell {
    
    private func dataBinding() {
        dataSource
            .asDriver()
            .drive(imageCollectionView.rx.items(
                cellIdentifier: ScreenShotImageCell.identifier,
                cellType: ScreenShotImageCell.self)) { row, image, cell in
                    cell.setScreenshot(image: image)
            }
            .disposed(by: disposeBag)
    }
    
    func setScreenShot(with model: ScreenShots) {
        Observable.from(model.urlStrings)
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
            .flatMap { API.shared.requestImage(urlString: $0) }
            .map{ UIImage(data: $0) }
            .reduce([UIImage?]()) { screenshots, screenshot in
                var images = screenshots
                images.append(screenshot)
                return images
        }
        .subscribe(onNext: dataSource.accept)
        .disposed(by: disposeBag)
    }
}
