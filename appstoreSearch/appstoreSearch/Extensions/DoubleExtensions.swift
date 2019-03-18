//
//  DoubleExtensions.swift
//  appstoreSearch
//
//  Created by Elon on 19/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import Foundation

extension Double {
    
    /**
     숫자에 콤마 추가 메소드
     
     - returns: (String) 콤마 추가된 숫자, 소수점 두자리
     */
    func withCommas() -> String {
        return String(format: "%.2f" , self).insertComma
    }
    
    /**
     입력한 소수점 자리 수 이하는 반올림 규칙에 맞춰 리턴함
     
     - Parameter places: 소수점 자리 수
     - Parameter rule: 반올림 규칙
     
     - returns: Double
     */
    func rounded(toPlaces places:Int, rule: FloatingPointRoundingRule) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(rule) / divisor
    }
}
