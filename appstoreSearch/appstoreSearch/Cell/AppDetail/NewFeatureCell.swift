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

extension NewFeatureCell {

    func initUI() {
        versionLabel.text = ""
        updateDateLabel.text = ""
        releaseNoteLabel.text = ""
        releaseNoteLabel.numberOfLines = 3
        readMoreButton.isHidden = true
    }
    
    func setVersion(by version: String) {
        versionLabel.text = "버전 \(version)"
    }
    
    func setUpdateLabel(releaseDate: Date) {
        //currentVersionReleaseDate
        //TODO: 한글 날짜 추가
    }
    
    func setReleaseNoteText(by releaseNote: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle : paragraphStyle,
            .font : UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        
        let attributedString = NSAttributedString(string: releaseNote,
                                                  attributes: attributes)
        if needExtened {
            let width = releaseNoteLabel.frame.width
            let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            
            let rect = attributedString.boundingRect(with: size,
                                                     options: .usesLineFragmentOrigin,
                                                     context: nil)
            
            releaseNoteLabel.bounds = rect
        }
        
        releaseNoteLabel.attributedText = attributedString
    }
    
    func setReleaseNote(by releaseNote: String) {
        let count = releaseNote.components(separatedBy: "\n").count
    
        if needExtened {
            readMoreButton.isHidden = true
            releaseNoteLabel.numberOfLines = count * 2
        } else if count > 3 {
            readMoreButton.isHidden = false
        }

        setReleaseNoteText(by: releaseNote)
    }
    
    func tapVersionHistory() {
        vesionHistorybutton
        .rx.tap
            .asDriver()
            .drive(onNext: {
                //데이터 없음
                Log.verbose("버전 히스토리")
            })
            .disposed(by: disposeBag)
    }
    
    func tapReadMore() {
        readMoreButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.readMore(true)
            })
            .disposed(by: disposeBag)
    }
    
    func setUI(with model: ResultElement, needExtened: Bool) {
        releaseNote = model.releaseNotes ?? ""
        self.needExtened = needExtened
        setVersion(by: model.version)
        setUpdateLabel(releaseDate: model.currentVersionReleaseDate)
        setReleaseNote(by: model.releaseNotes ?? "")
        tapVersionHistory()
        tapReadMore()
    }
    
}

class NewFeatureCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vesionHistorybutton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    @IBOutlet weak var releaseNoteLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!

    
    let disposeBag = DisposeBag()
    static let identifier = "NewFeatureCell"
    var needExtened: Bool = false
    var readMore: (Bool) -> Void = {_ in }
    var releaseNote: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
