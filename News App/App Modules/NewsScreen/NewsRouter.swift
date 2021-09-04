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
    
    func pushToNewDetailsScreen(for selected: NewEntity, navigationConroller: UINavigationController) {
        /*
         let albumDetailsModule = AlbumDetailsRouter.createModule(for: selected)
         navigationConroller.pushViewController(albumDetailsModule, animated: true)
         */
    }
    
}
