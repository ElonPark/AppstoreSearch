//
//  StringExtensions.swift
//  appstoreSearch
//
//  Created by Elon on 17/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import Foundation

extension String {
    /**
     정규식을 통해 문자열이 한글만 있는지 확인한다.(공백허용)
     
     - Returns: 허용된 경우 true
     */
    func isHangul() -> Bool {
        let regex = "^[ㄱ-ㅎㅏ-ㅣ가-힣\\s]{1,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
