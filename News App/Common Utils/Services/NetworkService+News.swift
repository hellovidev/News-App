//
//  NetworkService+News.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import Foundation

extension NetworkService {

    func getTopHeadlinesNews(completion: @escaping (Result<[NewEntity], Error>) -> Void) {
        guard let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) else {
            fatalError("Invalid Date")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let lastWeekDateString = dateFormatter.string(from: lastWeekDate)
        
        let parameters = [
            "category": "technology",
            "country": "us",
            "from": lastWeekDateString
        ]
        
        request(parameters: parameters, path: .topHeadlines, method: .GET, parser: ModelDeserializer<ArrayArticle>()) { result in
            completion(result.map { $0.articles })
        }
    }
    
    private struct ArrayArticle: Decodable {
        let articles: [NewEntity]
    }
    
}
