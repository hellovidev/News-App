//
//  NewsPresenter.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import UIKit

// MARK: - News Presenter
class NewsPresenter: ViewToPresenterNewsProtocol {
    var view: PresenterToViewNewsProtocol?
    var interactor: PresenterToInteractorNewsProtocol?
    var router: PresenterToRouterNewsProtocol?
    
    func fetchNews() {
        interactor?.fetchNews()
    }
    
    func fetchImageData(endpoint: String) {
        interactor?.fetchImageData(endpoint: endpoint)
    }
    
    func showNewDetailsController(for selected: NewEntity, navigationConroller: UINavigationController) {
        router?.pushToNewDetailsScreen(for: selected, navigationConroller: navigationConroller)
    }
    
}

// MARK: - Extension News Presenter For InteractorToPresenterProtocol
extension NewsPresenter: InteractorToPresenterNewsProtocol {
    func fetchImageDataRequestSuccess(for imageData: Data) {
        view?.onFetchImageDataRequestSuccess(for: imageData)
    }
    
    func fetchImageDataRequestFailed(_ error: Error) {
        view?.onFetchImageDataRequestFailed(error)
    }
    
    func fetchNewsRequestSuccess(for news: [NewEntity]) {
        view?.onFetchNewsResponseSuccess(for: news)
    }
    
    func fetchNewsRequestFailed(_ error: Error) {
        view?.onFetchNewsResponseFailed(error)
    }
    
}
