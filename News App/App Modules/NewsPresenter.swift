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
    
    func fetchNewsFromServer() {
        interactor?.fetchNewsFromServer()
    }
    
    func showNewDetailsController(for selected: NewEntity, navigationConroller: UINavigationController) {
        router?.pushToNewDetailsScreen(for: selected, navigationConroller: navigationConroller)
    }
    
}

// MARK: - Extension News Presenter For InteractorToPresenterProtocol
extension NewsPresenter: InteractorToPresenterNewsProtocol {
    func fetchNewsRequestSuccess(for news: [NewEntity]) {
        view?.onFetchNewsResponseSuccess(for: news)
    }
    
    func fetchNewsRequestFailed(_ error: Error) {
        view?.onFetchNewsResponseFailed(error)
    }
    
}
