//
//  Logger.swift
//  MarvelMoviesRank
//
//  Created by Elon on 07/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import Foundation

struct Log {
    
    private enum LogLevel: String {
        case verbose = "📢 VERBOSE"
        case debug = "🛠 DEBUG"
        case info = "💡 INFO"
        case warning = "⚠️ WARNING"
        case error = "🚨 ERROR"
    }
    
    private static func timeString() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 로케일 설정
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS" // 날짜 형식 설정
        let dateNow = dateFormatter.string(from: now)
        
        return dateNow
    }
    
    private static func logger(_ level: LogLevel, fileName: String, line: Int, funcName: String, output: Any...) {
        
        #if DEBUG
        if output.count < 2 {
            guard let printOut = output.first else { return }
            print("\(timeString()) \(level.rawValue) \(printOut) -> \(funcName) Line: \(line) \(fileName)")
        } else {
            print("\(timeString()) \(level.rawValue) ")
            for i in output {
                print(i)
            }
            
            print(" -> \(funcName) Line: \(line) \(fileName)")
        }
        #endif
    }
    
    static func verbose(fileName: String = #file, line: Int = #line, funcName: String = #function, _ output: Any...) {
        logger(.verbose, fileName: fileName, line: line, funcName: funcName, output: output)
    }
    
    static func debug(fileName: String = #file, line: Int = #line, funcName: String = #function, _ output: Any...) {
        logger(.debug, fileName: fileName, line: line, funcName: funcName, output: output)
    }
    
    static func info(fileName: String = #file, line: Int = #line, funcName: String = #function, _ output: Any...) {
        logger(.info, fileName: fileName, line: line, funcName: funcName, output: output)
    }
    
    static func warning(fileName: String = #file, line: Int = #line, funcName: String = #function, _ output: Any...) {
        logger(.warning, fileName: fileName, line: line, funcName: funcName, output: output)
    }
    
    static func error(fileName: String = #file, line: Int = #line, funcName: String = #function, _ output: Any...) {
        logger(.error, fileName: fileName, line: line, funcName: funcName, output: output)
    }
}
