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


extension ScreenShotCell {
    
    func dataBinding() {
        dataSource
            .observeOn(MainScheduler.instance)
            .bind(to: imageCollectionView.rx.items) { collectionView, item, urlString in
                let index = IndexPath(item: item, section: 0)
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ScreenShotImageCell.identifier,
                    for: index
                ) as! ScreenShotImageCell
                cell.setImage(by: urlString)
                
                return cell
            }
            .disposed(by: disposeBag)
    
    }
    
    func setScreenShot(with model: ResultElement) {
        dataSource.accept(model.screenshotURLs)
    }
}


class ScreenShotCell: UITableViewCell {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    static let identifier: String = "ScreenShotCell"
    
    lazy var dataSource = BehaviorRelay(value: [String]())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCollectionView.dataSource = nil
        imageCollectionView.delegate = nil
        dataBinding()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
