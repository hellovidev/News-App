//
//  WebViewProtocols.swift
//  News App
//
//  Created by Sergei Romanchuk on 07.09.2021.
//

import UIKit

// MARK: - View To Presenter Protocol

protocol ViewToPresenterWebViewProtocol {
    var router: PresenterToRouterWebViewProtocol? { get set }
    func closeWithError(_ error: Error, delegate: WebPreviewDelegate)
}

// MARK: - Presenter To Router Protocol

protocol PresenterToRouterWebViewProtocol {
    static func createModule(endpoint: String, with delegate: WebPreviewDelegate) -> WebViewController
    static var mainstoryboard: UIStoryboard { get }
    func closeWithError(_ error: Error, delegate: WebPreviewDelegate)
}

// MARK: - Parent Delegate Manager

protocol WebPreviewDelegate: AnyObject {
    func close(with error: Error)
}
