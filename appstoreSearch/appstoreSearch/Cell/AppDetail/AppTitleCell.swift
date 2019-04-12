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


final class AppTitleCell: UITableViewCell {
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    
    private let disposeBag = DisposeBag()
    static let identifier = "AppTitleCell"
    
    var etcAction: (() -> Void) = {}

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AppTitleCell {
    
    private func setAppIcon(by urlString: String) {
        appIconImageView
            .rx_setImage(by: urlString)
            .disposed(by: disposeBag)
    }
    
    private func setTitleLabel(to text: String) {
        titleLabel.text = text
    }
    
    private func setSubTitleLabel(to text: String) {
        subTitleLabel.text = text
    }
    
    private func setDownloadButton(title: String?) {
        var buttonTitle = title ?? "무료"
        if buttonTitle == "무료" {
            buttonTitle = "받기"
        }
        
        downloadButton.setTitle(buttonTitle, for: .normal)
        downloadButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }
    
    private func moveOutsideApp(to urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func tapDownload(with url: String) {
        downloadButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.moveOutsideApp(to: url)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func tapETCButton() {
        etcButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.etcAction()
            })
            .disposed(by: disposeBag)
    }
    
    func setUI(with model: TitleData) {
        setAppIcon(by: model.iconURLString)
        setTitleLabel(to: model.title)
        setSubTitleLabel(to: model.subTitle)
        setDownloadButton(title: model.price)
        tapDownload(with: model.appStoreURL)
        tapETCButton()
    }
}
