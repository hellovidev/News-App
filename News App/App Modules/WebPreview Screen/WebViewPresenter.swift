//
//  WebViewPresenter.swift
//  News App
//
//  Created by Sergei Romanchuk on 07.09.2021.
//

import Foundation

// MARK: - ViewToPresenterWebViewProtocol

class WebViewPresenter: ViewToPresenterWebViewProtocol {
    
    var router: PresenterToRouterWebViewProtocol?
    
    func closeWithError(_ error: Error, delegate: WebPreviewDelegate) {
        router?.closeWithError(error, delegate: delegate)
    }
    
}
