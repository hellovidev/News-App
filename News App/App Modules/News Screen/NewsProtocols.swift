//
//  NewsProtocols.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import UIKit

// MARK: - Entity Protocol

protocol NewEntityProtocol: Identifiable, Codable {
    var id: String { get }
    var author: String? { get }
    var title: String { get }
    var description: String? { get }
    var url: String { get }
    var urlToImage: String? { get }
    var publishedAt: String { get }
}

// MARK: - View To Presenter Protocol

protocol ViewToPresenterNewsProtocol {
    var view: PresenterToViewNewsProtocol? { get set }
    var interactor: PresenterToInteractorNewsProtocol? { get set }
    var router: PresenterToRouterNewsProtocol? { get set }
    func fetchNews(for day: Int)
    func openArticle(url: String, from: UIViewController, navigationController: UINavigationController)
    func closeArticle(navigationController: UINavigationController)
}

// MARK: - Presenter To View Protocol

protocol PresenterToViewNewsProtocol {
    func onFetchNewsResponseSuccess(for news: [NewEntity])
    func onFetchNewsResponseFailed(_ error: Error)
}

// MARK: - Presenter To Router Protocol

protocol PresenterToRouterNewsProtocol {
    static func createModule() -> NewsViewController
    static var mainstoryboard: UIStoryboard { get }
    func openArticle(url: String, from: UIViewController, navigationController: UINavigationController)
    func closeArticle(navigationController: UINavigationController)
}

// MARK: - Presenter To Interactor Protocol

protocol PresenterToInteractorNewsProtocol {
    var presenter: InteractorToPresenterNewsProtocol? { get set }
    func fetchNews(for day: Int)
}

// MARK: - Interactor To Presenter Protocol

protocol InteractorToPresenterNewsProtocol {
    func fetchNewsRequestSuccess(for news: [NewEntity])
    func fetchNewsRequestFailed(_ error: Error)
}
