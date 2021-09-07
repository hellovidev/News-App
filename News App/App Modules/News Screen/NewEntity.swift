//
//  NewEntity.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import Foundation

struct NewEntity: NewEntityProtocol, Decodable {
    
    var id: String = UUID().uuidString
    
    var author: String?
    
    var title: String
    
    var description: String?
    
    var url: String
    
    var urlToImage: String?
    
    var publishedAt: String
    
    enum CodingKeys: CodingKey {
        case author, title, description, url, urlToImage, publishedAt
    }
    
}
