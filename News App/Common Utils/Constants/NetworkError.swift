//
//  NetworkError.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case badRequest
    case failed
    case noData
    case noHttpResponse
    case unableToDecode
    case outdated
    case authentificationError
}
