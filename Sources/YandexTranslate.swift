//
//  Translate.swift
//  SwiftYandexTranslateAPI
//
//  Created by Muh Rusdi on 1/24/17.
//
//

import Foundation

open class YandexTranslate {
    public var apiKey: String?
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    open func translate(text source: String, lang: Language, completion: @escaping (_ result: String) -> ()) {
        guard apiKey == nil else {
            print("apikey nil")
            return
        }
        
        if let textAllow = source.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            if let url = URL(string: "https://translate.yandex.net/api/v1.5/tr.json/translate?key=\(apiKey)&text=\(textAllow)&lang=\(lang.rawValue)") {
                let session = URLSession.shared
                let task = session.dataTask(with: url) { data, response, error in
                    guard error == nil else {
                        print("erro session")
                        return
                    }
                    
                    guard (response as! HTTPURLResponse).statusCode == 200 else {
                        print("data error")
                        return
                    }
                    if let data = data {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject], let result = json?["text"] as? [String]  {
                            completion(result.first!)
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
