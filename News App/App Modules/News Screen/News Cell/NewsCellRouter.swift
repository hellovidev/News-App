//
//  NewsCellRouter.swift
//  News App
//
//  Created by Sergei Romanchuk on 04.09.2021.
//

import UIKit

// MARK: - PresenterToRouterNewsProtocol

class NewsCellRouter: PresenterToRouterNewsCellProtocol {
    
    static func createModule(tableView: UITableView, indexPath: IndexPath, article: Article) -> NewsTableViewCell {
        
        let view = tableView.dequeueReusableCell(withIdentifier: Cell.news.rawValue, for: indexPath) as! NewsTableViewCell
        var presenter: ViewToPresenterNewsCellProtocol & InteractorToPresenterNewsCellProtocol = NewsCellPresenter()
        var interactor: PresenterToInteractorNewsCellProtocol = NewsCellInteractor()
        let router: PresenterToRouterNewsCellProtocol = NewsCellRouter()
        
        // Module Initialization
        view.newsCellPresenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        view.indexPath = indexPath
        view.configure(with: article)
        
        return view
    }
    
    func showWebPreview(indexPath: IndexPath, delegate: CellNavigationDelegate) {
        delegate.redirect(indexPath: indexPath)
    }
    
}
