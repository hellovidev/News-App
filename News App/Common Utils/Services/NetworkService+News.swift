//
//  NetworkService+News.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import Foundation

extension NetworkService {
    
    func getTopHeadlinesNews(completion: @escaping (Result<[NewEntity], Error>) -> Void) {
        let parameters = [
            "category": "technology"
        ]
        
        request(parameters: parameters, path: .topHeadlines, method: .GET, parser: ModelDeserializer<ArrayArticle>()) { result in
            completion(result.map { $0.articles })
        }
    }
    
    private struct ArrayArticle: Decodable {
        let articles: [NewEntity]
    }
    
}
