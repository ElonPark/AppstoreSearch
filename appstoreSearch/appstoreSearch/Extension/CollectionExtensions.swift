//
//  CollectionExtensions.swift
//  appstoreSearch
//
//  Created by Elon on 19/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import Foundation

extension Collection {
    
    /**
     배열에 포함되지 않는 인덱스인 경우 nil을 리턴한다.
     
     - Parameter index: 접근할 인덱스
     - Returns: 값이 존재하지 않을 경우 nil.
     */
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
