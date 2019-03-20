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
    
    /**
     파라미터로 넘어온 문자열이 자신의 문자열들과 일치하는지 확인한다.
     
     - Parameters: 확인할 문자열
     - Returns: 앞이 일치하는지 여부
     */
    func hasCaseInsensitivePrefix(_ string: String) -> Bool {
        return prefix(string.count).caseInsensitiveCompare(string) == .orderedSame
    }
    
    /**
     문자열에 자모가 존재할 경우 제거
     (ex: "카카오ㅌ" -> "카카오")
     
     - Returns: 자모가 제거된 문자열
     */
    func removeJamo() -> String {
        let jamo: [Character] = [
            "ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ",
            "ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ",
            
            "ㄳ","ㄵ","ㄶ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅄ",
            
            "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ","ㅕ", "ㅖ", "ㅗ", "ㅘ",
            "ㅙ", "ㅚ","ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ",
            "ㅣ"
        ]
        
        var result: String = ""
        
        for case let unit in Array(self) where !jamo.contains(unit) {
            result.append(unit)
        }
        
        return result
    }
    
    var insertComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        
        var numberArray = self.components(separatedBy: ".")
        
        if numberArray.count == 1 {
            let numberString = numberArray[0].replacingOccurrences(of: ",", with: "")
            
            guard let doubleValue = Double(numberString) else { return self }
            
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
            
        } else if numberArray.count == 2 {
            let numberString = numberArray[0]
            guard let doubleValue = Double(numberString) else { return self }
            
            return (numberFormatter.string(from: NSNumber(value: doubleValue)) ?? numberString) + ".\(numberArray[1])"
        }else{
            guard let doubleValue = Double(self) else { return self }
            
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
    }
}
