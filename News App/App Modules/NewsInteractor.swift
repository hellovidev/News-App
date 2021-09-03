//
//  NewsInteractor.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import Foundation

// MARK: - News Interactor
class NewsInteractor: PresenterToInteractorNewsProtocol {
    var presenter: InteractorToPresenterNewsProtocol?
    private let networkService: NetworkService = .init()
    
    func fetchNewsFromServer() {
        
        networkService.getTopHeadlinesNews { result in
            switch result {
            case .success(let news):
                self.presenter?.fetchNewsRequestSuccess(for: news)
            case .failure(let error):
                self.presenter?.fetchNewsRequestFailed(error)
            }
        }
    }
    
}
