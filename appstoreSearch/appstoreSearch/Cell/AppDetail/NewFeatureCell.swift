//
//  NewFeatureCell.swift
//  appstoreSearch
//
//  Created by Elon on 21/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class NewFeatureCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vesionHistorybutton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    @IBOutlet weak var releaseNoteLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!

    
    private let disposeBag = DisposeBag()
    static let identifier = "NewFeatureCell"
    var needExtened: Bool = false
    var readMore: (Bool) -> Void = {_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
}

extension NewFeatureCell {
    
    private func initUI() {
        versionLabel.text = ""
        updateDateLabel.text = ""
        releaseNoteLabel.text = ""
        releaseNoteLabel.numberOfLines = 3
        readMoreButton.isHidden = true
    }
    
    private func setVersion(by version: String) {
        versionLabel.text = "버전 \(version)"
    }
    
    private func setUpdateLabel(releaseDate: Date) {
        //currentVersionReleaseDate
        //TODO: 한글 날짜 추가
    }
    
    private func setReleaseNote(by releaseNote: String) {
        let count = releaseNote.components(separatedBy: "\n").count
        
        if needExtened {
            readMoreButton.isHidden = true
        } else if count > 3 {
            readMoreButton.isHidden = false
        }
        
        releaseNoteLabel.extendable(text: releaseNote,
                                    extened: needExtened,
                                    lineHeightMultiple: true)
    }
    
    private func tapVersionHistory() {
        vesionHistorybutton
            .rx.tap
            .asDriver()
            .drive(onNext: {
                //데이터 없음
                Log.verbose("버전 히스토리")
            })
            .disposed(by: disposeBag)
    }
    
    private func tapReadMore() {
        readMoreButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.readMore(true)
            })
            .disposed(by: disposeBag)
    }
    
    func setUI(with model: ReleaseNote) {
        self.needExtened = model.needExtened
        setVersion(by: model.version)
        setUpdateLabel(releaseDate: model.updateDate)
        setReleaseNote(by: model.text)
        tapVersionHistory()
        tapReadMore()
    }
}
