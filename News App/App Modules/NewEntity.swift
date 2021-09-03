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



//"author": "Pete Thamel",
//"title": "'We are the big school' – On seminal night, UCF shows glimpse of future and what Big 12 membership could bring - Yahoo Sports",
//"description": "UCF won in coach Gus Malzahn’s debut on the field, 36-31 . That paled in comparison to the news that emerged out of the Big 12.",
//"url": "https://sports.yahoo.com/we-are-the-big-school-on-seminal-night-ucf-shows-glimpse-of-future-and-what-big-12-membership-could-bring-071227432.html",
//"urlToImage": "https://s.yimg.com/ny/api/res/1.2/AcsNCeI3910mTFC19FjbCQ--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD04MDA-/https://s.yimg.com/os/creatr-uploaded-images/2021-09/a86ee8e0-0c84-11ec-a5ff-bfd66d5f600e",
//"publishedAt": "2021-09-03T07:12:27Z",
