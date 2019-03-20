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
        starRatingView.isHidden = true
        ratingLabel.text = ""
        
        for screenShotView in screenShotImageViews {
            screenShotView.image = nil
            screenShotView.isHidden = true
        }
    }
    
    private func loadImage(to imageView: UIImageView, by urlString: String) {
        API.shared.requestImage(urlString: urlString)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .retry(2)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { imageData in
                let image = UIImage(data: imageData)
                imageView.image = image
                imageView.isHidden = false
            }, onError: { error in
                Log.error(error.localizedDescription, error)
                imageView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
    
    func setAppIconImageView(by urlString: String) {
        loadImage(to: appIconImageView, by: urlString)
    }
    
    func setTitleLabel(text: String) {
        titleLabel.text = text
    }
    
    func setSubTitleLabel(text: String?) {
        subTitleLabel.text = text
    }
    
    func setStarRating(value: Double?) {
        starRatingView.isHidden = value == nil ? true : false
        guard let averageUserRating = value else { return }
        starRatingView.settings.fillMode = .precise
        starRatingView.settings.updateOnTouch = false
        starRatingView.rating = averageUserRating
    }
    
    func setRatingLabel(value: Int?) {
        guard let userRatingCount = value else { return }
        let ratingCountText = { (number: Double) -> String in
            var count = Double(userRatingCount) / number
            count = count.rounded(toPlaces: 2, rule: .up)
            
            return count.withCommas()
        }
        
        var ratingText = String(userRatingCount)
        
        if userRatingCount > 10000 {
            ratingText = "\(ratingCountText(10000.0))만"
        } else if userRatingCount > 1000 {
            ratingText = "\(ratingCountText(1000.0))천"
        }
        
        ratingLabel.text = ratingText
    }
    
    func setScreenShotImageViews(by urlStrings: [String]) {
        for index in 0..<screenShotImageViews.count {
            let imageView = screenShotImageViews[index]
            if let urlString = urlStrings[safe: index] {
                loadImage(to: screenShotImageViews[index], by: urlString)
            } else {
                imageView.isHidden = true
            }
        }
    }
    
    ///다운로드를 누르면 앱스토어 앱 상세페이지로 이동
    func rx_downlaod() {
        downloadButton
            .rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .bind { [unowned self] in
                guard let appStoreID = self.resultElement?.trackID else { return }
                let appStoreURLString = "itms-apps://tunes.apple.com/app/id\(appStoreID)"
                guard let url = URL(string: appStoreURLString) else { return }
                UIApplication.shared.open(url)
            }
            .disposed(by: disposeBag)
    }
    
    func setUI(with model: ResultElement) {
        resultElement = model
        setAppIconImageView(by: model.artworkURL100)
        setTitleLabel(text: model.trackName)
        setSubTitleLabel(text: model.genres[safe: 0])
        setStarRating(value: model.averageUserRating)
        setRatingLabel(value: model.userRatingCount)
        setScreenShotImageViews (by: model.screenshotURLs)
        
        rx_downlaod()
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
