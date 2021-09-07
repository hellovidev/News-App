//
//  WebViewRouter.swift
//  News App
//
//  Created by Sergei Romanchuk on 07.09.2021.
//

import UIKit

// MARK: - PresenterToRouterWebViewProtocol

class WebViewRouter: PresenterToRouterWebViewProtocol {

    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name: Storyboard.main.rawValue, bundle: Bundle.main)
    }
    
    static func createModule(endpoint: String, with delegate: WebPreviewDelegate) -> WebViewController {
        
        let view = NewsRouter.mainstoryboard.instantiateViewController(identifier: Controller.webView.rawValue) as! WebViewController
        
        var presenter: ViewToPresenterWebViewProtocol = WebViewPresenter()
        let router: PresenterToRouterWebViewProtocol = WebViewRouter()
        
        // Module Initialization
        view.webViewPresenter = presenter
        view.delegate = delegate
        view.setEndpoint(endpoint)
        
        presenter.router = router
        
        return view
    }
    
    func closeWithError(_ error: Error, delegate: WebPreviewDelegate) {
        delegate.close(with: error)
    }
    
}
