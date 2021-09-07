//
//  NewsCellInteractor.swift
//  News App
//
//  Created by Sergei Romanchuk on 04.09.2021.
//

import Foundation
import Combine

// MARK: - PresenterToInteractorNewsCellProtocol

class NewsCellInteractor: PresenterToInteractorNewsCellProtocol {
    
    private let networkService: NetworkService = .init()
    private var cancellable: AnyCancellable?
    
    var presenter: InteractorToPresenterNewsCellProtocol?
    
    func fetchImageData(endpoint: String) {
        cancellable = networkService.imageRequest(for: endpoint).sink { [unowned self] data in
            switch data {
            case .none:
                self.presenter?.fetchImageDataRequestFailed(NetworkError.noData)
            case .some(let data):
                self.presenter?.fetchImageDataRequestSuccess(for: data)
            }
        }
    }
    
}
