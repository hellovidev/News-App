//
//  Deserializer.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import Foundation

protocol Deserializer {
    associatedtype Response
    func parse(data: Data) throws -> Response
}

//struct VoidDeserializer: Deserializer {
//    typealias Response = Void
//
//    func parse(data: Data) throws -> Void {
//        guard let response = String(data: data, encoding: .utf8) else { return }
//        print("Server answer: \(response)")
//    }
//}

struct ModelDeserializer<T: Decodable>: Deserializer {
    typealias Response = T
    
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
    
    func parse(data: Data) throws -> T {
        do {
            let response = try decoder.decode(T.self, from: data)
            return response
        } catch {
            print(error)
            throw NetworkError.decodingFailed
        }
    }
}
