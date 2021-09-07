//
//  NetworkService+News.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import Foundation
import Combine

extension NetworkService {

    func getTopHeadlinesNews(for day: Int, completion: @escaping (Result<[NewEntity], Error>) -> Void) {
        guard let toDate = Calendar.current.date(byAdding: .day, value: -(day-1), to: Date()) else {
            fatalError("Invalid Date")
        }
        
        guard let earlyHourDate = Calendar.current.date(byAdding: .day, value: -day, to: Date()) else {
            fatalError("Invalid Date")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let earlyHourDateString = dateFormatter.string(from: earlyHourDate)
        let toDateString = dateFormatter.string(from: toDate)
        
        print("from:\(earlyHourDateString) \nto:\(toDateString)")
        let parameters = [
            "from": earlyHourDateString,
            "to": toDateString,
            "sortBy": "popularity",
            "language": "en",
            "q": "bitcoin"
        ]
        
        request(parameters: parameters, path: .everything, method: .GET, parser: ModelDeserializer<ArrayArticle>()) { result in
            completion(result.map { $0.articles })
        }
    }
    
    private struct ArrayArticle: Decodable {
        let articles: [NewEntity]
    }
    
    func imageRequest(for url: String) -> AnyPublisher<Data?, Never> {
        return Just(url)
            .flatMap(
                { poster -> AnyPublisher<Data?, Never> in
                    guard let url = URL(string: url) else { fatalError() }
                    return ImageLoader.shared.loadImage(from: url)
                }
            )
            .eraseToAnyPublisher()
    }
    
}
