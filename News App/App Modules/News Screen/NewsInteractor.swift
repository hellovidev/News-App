//
//  NewsInteractor.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import Foundation

// MARK: - PresenterToInteractorNewsProtocol

class NewsInteractor: PresenterToInteractorNewsProtocol {
    
    private let networkService: NetworkService = .init()
    
    var presenter: InteractorToPresenterNewsProtocol?
        
    func fetchNews(for day: Int) {
        networkService.getTopHeadlinesNews(for: day) { result in
            switch result {
            case .success(let news):
                self.presenter?.fetchNewsRequestSuccess(for: news)
            case .failure(let error):
                self.presenter?.fetchNewsRequestFailed(error)
            }
        }
    }
    
}
