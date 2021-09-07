//
//  Endpoint.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import Foundation

enum Endpoint: String {
    case baseURL = "https://newsapi.org/v2/"
    
    enum Path: String {
        case everything = "everything"
        case topHeadlines = "top-headlines"
    }
}
