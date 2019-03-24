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
        }
    }
    
    func setAppIconImageView(by urlString: String) {
        appIconImageView
            .rx_setImage(by: urlString)
            .disposed(by: disposeBag)
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
    
    ///TODO: 이미지 로딩 개선
    func setScreenShotImageViews(by urlStrings: [String]) {
        for index in 0..<screenShotImageViews.count {
            let imageView = screenShotImageViews[index]
            if let urlString = urlStrings[safe: index] {
                imageView
                    .rx_setImage(by: urlString)
                    .disposed(by: disposeBag)
            } else {
                imageView.isHidden = true
            }
        }
    }
    
    func setDownloadButton(title: String?) {
        var buttonTitle = title ?? "무료"
        if buttonTitle == "무료" {
            buttonTitle = "받기"
        }
        
        downloadButton.setTitle(buttonTitle, for: .normal)
        downloadButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }
    
    ///다운로드를 누르면 앱스토어 앱 상세페이지로 이동
    func tapDownload(with url: String) {
        downloadButton
            .rx.tap
            .asDriver()
            .drive(onNext: {
                guard let url = URL(string: url) else { return }
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
    }
    
    func setUI(with model: ResultElement) {
        resultElement = model
        setAppIconImageView(by: model.artworkURL100)
        setTitleLabel(text: model.trackName)
        setSubTitleLabel(text: model.genres[safe: 0])
        setStarRating(value: model.averageUserRatingForCurrentVersion)
        setRatingLabel(value: model.userRatingCountForCurrentVersion)
        setScreenShotImageViews(by: model.screenshotURLs)
        setDownloadButton(title: model.formattedPrice)
        tapDownload(with: model.trackViewURL)
        
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
}
