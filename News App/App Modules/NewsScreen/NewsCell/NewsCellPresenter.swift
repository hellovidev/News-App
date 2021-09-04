//
//  NewsCellPresenter.swift
//  News App
//
//  Created by Sergei Romanchuk on 04.09.2021.
//

import Foundation

// MARK: - ViewToPresenterNewsCellProtocol

class NewsCellPresenter: ViewToPresenterNewsCellProtocol {
    
    var view: PresenterToViewNewsCellProtocol?
    
    var interactor: PresenterToInteractorNewsCellProtocol?
    
    var router: PresenterToRouterNewsCellProtocol?
    
    func fetchImageData(endpoint: String) {
        interactor?.fetchImageData(endpoint: endpoint)
    }
    
}

// MARK: - InteractorToPresenterNewsCellProtocol

extension NewsCellPresenter: InteractorToPresenterNewsCellProtocol {
    
    func fetchImageDataRequestSuccess(for imageData: Data) {
        view?.onFetchImageDataResponseSuccess(for: imageData)
    }

    func fetchImageDataRequestFailed(_ error: Error) {
        view?.onFetchImageDataResponseFailed(error)
    }
    
}
