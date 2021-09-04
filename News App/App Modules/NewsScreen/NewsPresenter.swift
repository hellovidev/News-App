//
//  NewsPresenter.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import UIKit

// MARK: - ViewToPresenterNewsProtocol

class NewsPresenter: ViewToPresenterNewsProtocol {
    
    var view: PresenterToViewNewsProtocol?
    
    var interactor: PresenterToInteractorNewsProtocol?
    
    var router: PresenterToRouterNewsProtocol?
    
    func fetchNews(for day: Int) {
        interactor?.fetchNews(for: day)
    }

    func showNewDetailsController(for selected: NewEntity, navigationConroller: UINavigationController) {
        router?.pushToNewDetailsScreen(for: selected, navigationConroller: navigationConroller)
    }
    
}

// MARK: - InteractorToPresenterNewsProtocol

extension NewsPresenter: InteractorToPresenterNewsProtocol {

    func fetchNewsRequestSuccess(for news: [NewEntity]) {
        view?.onFetchNewsResponseSuccess(for: news)
    }
    
    func fetchNewsRequestFailed(_ error: Error) {
        view?.onFetchNewsResponseFailed(error)
    }
    
}
