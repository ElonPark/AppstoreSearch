//
//  API.swift
//  appstoreSearch
//
//  Created by Elon on 17/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import Foundation
import RxSwift

enum HTTP: String {
    case get = "GET"
    case post = "POST"
}

final class API {
    
    static var shared = API()
    let hostURL = "https://itunes.apple.com"
    let endpoint = "/search"
    
    private init() {}
    
    private func requsetURL(_ urlString: String, with parameters: [String : String]? = nil) -> URL? {
        var urlComponents = URLComponents(string: urlString)
        
        if let _parameters = parameters {
           let query = _parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }

            urlComponents?.queryItems = query
        }
        
        
        return urlComponents?.url
    }
    
    func searchAppsotre(by keyword: String) -> Observable<Result> {
        let parameter = [
            "term" : keyword,
            "media" : "software",
            "entity" : "software",
            "limit" : "5",
            "lang" : "ko_kr",
            "country" : "kr"
        ]
        
        let url = requsetURL(hostURL + endpoint, with: parameter)
   
        return requestSearchResult(by: url)
    }
    
    private func requestSearchResult(by requsetURL: URL?) -> Observable<Result> {
        return Observable.create { [unowned self] observer in
            guard let url = requsetURL else {
                observer.onError(APIError.url)
                return Disposables.create()
            }
            
            let task = self.request(with: url, method: .get) { data, requsetError in
                if let error = requsetError {
                    observer.onError(error)
                } else {
                    do {
                        let result = try Result(data: data)
                        observer.onNext(result)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            
            return Disposables.create(with: task.cancel)
        }
    }
    
    func requestImage(urlString: String) -> Observable<Data> {
        return Observable.create { [unowned self] observer in
            guard let url = self.requsetURL(urlString) else {
                observer.onError(APIError.url)
                return Disposables.create()
            }
            
            let task = self.request(with: url, method: .get) { responseData, requsetError in
                if let error = requsetError {
                    observer.onError(error)

                } else if let data = responseData {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onError(APIError.responseData)
                }
            }
            
            return Disposables.create(with: task.cancel)
        }
    }
    
    
    private func request(with url: URL, method: HTTP, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = method.rawValue
        
        URLSession.shared.configuration.waitsForConnectivity = true
        let task = URLSession.shared.dataTask(with: request) { responseData, urlResponse, requsetError in
            var error: Error? = nil
            defer {
                completion(responseData, error)
            }
    
            guard requsetError == nil else {
                error = requsetError
                return
            }
            
            guard let response = urlResponse as? HTTPURLResponse else {
                error = APIError.response
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                error = APIError.statusCode(response.statusCode)
                return
            }
        }
        task.resume()
        
        return task
    }
}
