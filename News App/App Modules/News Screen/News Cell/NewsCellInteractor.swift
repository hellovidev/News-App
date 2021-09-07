//
//  NewsCellInteractor.swift
//  News App
//
//  Created by Sergei Romanchuk on 04.09.2021.
//

import Foundation

// MARK: - PresenterToInteractorNewsCellProtocol

class NewsCellInteractor: PresenterToInteractorNewsCellProtocol {
    
    private let networkService: NetworkService = .init()

    var presenter: InteractorToPresenterNewsCellProtocol?
    
    func fetchImageData(endpoint: String) {
        networkService.loadImageByURL(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                self.presenter?.fetchImageDataRequestSuccess(for: data)
            case .failure(let error):
                self.presenter?.fetchImageDataRequestFailed(error)
            }

        }
    }

}
