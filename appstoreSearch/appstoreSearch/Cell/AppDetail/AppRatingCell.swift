//
//  AppRatingCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cosmos


final class AppRatingCell: UITableViewCell {

    @IBOutlet weak var ratingScoreLabel: UILabel!
    @IBOutlet weak var ratingScoreLabelCostraintWidth: NSLayoutConstraint!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageTitleLabel: UILabel!
    
    
    
    private let disposeBag = DisposeBag()
    static let identifier = "AppRatingCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
}

extension AppRatingCell {
    
    private func initUI() {
        ratingScoreLabel.text = ""
        ratingScoreLabelCostraintWidth.constant = 0
        starRatingView.rating = 0
        starRatingView.settings.starSize = 30
        starRatingView.settings.updateOnTouch = false
        
        ratingCountLabel.text = "평기부족"
        rankLabel.text = ""
        categoryLabel.text = ""
        ageLabel.text = ""
        ageTitleLabel.text = "연령"
    }
    
    private func setRatingLabel(by userRating: Double?) {
        guard let rating = userRating else { return }
        ratingScoreLabelCostraintWidth.constant = 30
        ratingScoreLabel.text = String(rating)
    }
    
    private func setStarRating(by userRating: Double?) {
        guard let rating = userRating else { return }
        
        starRatingView.rating = rating
        starRatingView.settings.starSize = 20
    }
    
    private func setRatingCount(by ratingCount: Int?) {
        guard let userRatingCount = ratingCount else { return }
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
        
        ratingCountLabel.text = ratingText + "개의 평가"
    }
    
    ///데이터 없음
    private func setRank(by rank: Int = 0) {
        rankLabel.text = "#\(rank)"
    }
    
    private func setCategory(by category: String?) {
        guard let primaryCategory = category else { return }
        categoryLabel.text = primaryCategory
    }
    
    private func setAge(by age: String) {
        ageLabel.text = age
    }
    
    func setUI(with model: Rating) {
        setRatingLabel(by: model.userRating)
        setStarRating(by: model.userRating)
        setRatingCount(by: model.userRatingCount)
        setRank()
        setCategory(by: model.category[0])
        setAge(by: model.contentRating)
    }
}
