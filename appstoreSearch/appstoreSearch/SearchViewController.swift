//
//  SearchViewController.swift
//  appstoreSearch
//
//  Created by Elon on 16/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



//TODO: 검색창에는 한글 입력만 가능하도록 구현
//TODO:  인기 검색어 대신 최근 검색어로 교체하여 구현(표시는 최대 10개)
//TODO: 검색시 연관검색어 대신 히스토리에서 검색하여 표시
//TODO: 검색 결과 화면은 스크린샷과 동일하게 구현
//TODO: 상세 화면은 제공되는 API내에서 최대한 구현

class SearchViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FIXME: 따로 메소드로 분리 예정
        API.shared.searchAppsotre(by: "카카오뱅크")
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .retry(2)
            .subscribe(onNext: { result in
                Log.verbose("성공")
            }, onError: { error in
                Log.error(error.localizedDescription)
            }, onCompleted: {
                Log.verbose("onCompleted")
            })
            .disposed(by: disposeBag)
    }
}

