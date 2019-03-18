//
//  SearchResultCell.swift
//  appstoreSearch
//
//  Created by Elon on 18/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cosmos

extension SearchResultCell {
    
    func initCell() {
        appIconImageView.image = nil
        titleLabel.text = ""
        subTitleLabel.text = ""
    }
    
    func setScreenShotImageViews(by urlStrings: [String]) {
        
    }
    
    
    ///다운로드를 누르면 앱스토어 앱 상세페이지로 이동
    func downlaod() {
        downloadButton
            .rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .bind { [unowned self] in
                guard let appStoreID = self.resultElement?.trackID else { return }
                let appStoreURLString = "itms://tunes.apple.com/app/id\(appStoreID)"
                guard let url = URL(string: appStoreURLString) else { return }
                UIApplication.shared.open(url)
            }
            .disposed(by: disposeBag)
    }
    
}

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var userRatingView: UIView!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var screenShotStackView: UIStackView!
    @IBOutlet var screenShotImageViews: [UIImageView]!
    
    
    let disposeBag = DisposeBag()
    static let identifier = "SearchResultCell"
    
    var resultElement: ResultElement? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        initCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
