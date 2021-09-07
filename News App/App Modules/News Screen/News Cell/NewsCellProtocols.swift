//
//  NewsCellProtocols.swift
//  News App
//
//  Created by Sergei Romanchuk on 04.09.2021.
//

import UIKit

// MARK: - View To Presenter Protocol

protocol ViewToPresenterNewsCellProtocol {
    var view: PresenterToViewNewsCellProtocol? { get set }
    var interactor: PresenterToInteractorNewsCellProtocol? { get set }
    var router: PresenterToRouterNewsCellProtocol? { get set }
    func fetchImageData(endpoint: String)
    func showWebPreview(indexPath: IndexPath, delegate: CellNavigationDelegate)
}

// MARK: - Presenter To View Protocol

protocol PresenterToViewNewsCellProtocol {
    func onFetchImageDataResponseSuccess(for imageData: Data)
    func onFetchImageDataResponseFailed(_ error: Error)
}

// MARK: - Presenter To Router Protocol

protocol PresenterToRouterNewsCellProtocol {
    static func createModule(tableView: UITableView, indexPath: IndexPath, article: NewEntity) -> NewsTableViewCell
    func showWebPreview(indexPath: IndexPath, delegate: CellNavigationDelegate)
}

// MARK: - Presenter To Interactor Protocol

protocol PresenterToInteractorNewsCellProtocol {
    var presenter: InteractorToPresenterNewsCellProtocol? { get set }
    func fetchImageData(endpoint: String)
}

// MARK: - Interactor To Presenter Protocol

protocol InteractorToPresenterNewsCellProtocol {
    func fetchImageDataRequestSuccess(for imageData: Data)
    func fetchImageDataRequestFailed(_ error: Error)
}
