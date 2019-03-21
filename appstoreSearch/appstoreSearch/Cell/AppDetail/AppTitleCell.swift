//
//  AppTitleCell.swift
//  appstoreSearch
//
//  Created by Elon on 20/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension AppTitleCell {
    
    func setAppIcon(by urlString: String) {
        appIconImageView
            .rx_setImage(by: urlString)
            .disposed(by: disposeBag)
    }
    
    func setTitleLabel(to text: String) {
        titleLabel.text = text
    }
    
    func setSubTitleLabel(to text: String) {
        subTitleLabel.text = text
    }
    
    func setDownloadButton(title: String?) {
        var buttonTitle = title ?? "무료"
        if buttonTitle == "무료" {
            buttonTitle = "받기"
        }
        
        downloadButton.setTitle(buttonTitle, for: .normal)
        downloadButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }
    
    func moveOutsideApp(to urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    func tapDownload(with appStoreID: Int) {
        downloadButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let appStoreURL = "itms-apps://tunes.apple.com/app/id\(appStoreID)"
                self?.moveOutsideApp(to: appStoreURL)
            })
            .disposed(by: disposeBag)
    }
    
    
    
    func tapETCButton(with data: ResultElement) {
        etcButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.etcAction()
            })
            .disposed(by: disposeBag)
    }
    
    func setUI(with model: ResultElement) {
        setAppIcon(by: model.artworkURL512)
        setTitleLabel(to: model.trackName)
        setSubTitleLabel(to: model.artistName)
        setDownloadButton(title: model.formattedPrice)
        tapDownload(with: model.trackID)
        tapETCButton(with: model)
    }
}


class AppTitleCell: UITableViewCell {
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    
    let disposeBag = DisposeBag()
    static let identifier = "AppTitleCell"
    
    var etcAction: (() -> Void) = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
