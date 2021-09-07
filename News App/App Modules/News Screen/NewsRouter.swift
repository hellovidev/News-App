//
//  NewsRouter.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import UIKit

// MARK: - PresenterToRouterNewsProtocol

class NewsRouter: PresenterToRouterNewsProtocol {
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name: Storyboard.main.rawValue, bundle: Bundle.main)
    }
    
    static func createModule() -> NewsViewController {
        
        let view = NewsRouter.mainstoryboard.instantiateViewController(identifier: Controller.news.rawValue) as! NewsViewController
        var presenter: ViewToPresenterNewsProtocol & InteractorToPresenterNewsProtocol = NewsPresenter()
        var interactor: PresenterToInteractorNewsProtocol = NewsInteractor()
        let router: PresenterToRouterNewsProtocol = NewsRouter()
        
        // Module Initialization
        view.newsPresenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func openArticle(url: String, from: UIViewController, navigationController: UINavigationController) {
        let viewController = WebViewRouter.createModule(endpoint: url, with: from as! WebPreviewDelegate)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func closeArticle(navigationController: UINavigationController) {
        navigationController.popViewController(animated: true)
    }
    
}
