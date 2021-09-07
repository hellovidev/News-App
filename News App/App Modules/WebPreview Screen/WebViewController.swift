//
//  WebViewController.swift
//  News App
//
//  Created by Sergei Romanchuk on 06.09.2021.
//

import UIKit
import WebKit

enum WebViewError: Error {
    case message(_ message: String)
}

extension WebViewError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .message(let message):
            return message
        }
    }
}

class WebViewController: UIViewController {
    
    var webViewPresenter: ViewToPresenterWebViewProtocol?
    
    weak var delegate: WebPreviewDelegate?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var endpoint: String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        guard let endpoint = endpoint else {
            webViewPresenter?.closeWithError(WebViewError.message("Empty URL path."), delegate: delegate!)
            return
        }
        
        guard let url = URL(string: endpoint) else {
            webViewPresenter?.closeWithError(WebViewError.message("Invalid URL."), delegate: delegate!)
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    func setEndpoint(_ endpoint: String) {
        self.endpoint = endpoint
    }
    
    deinit {
        print("\(type(of: self)) deinit.")
    }
    
}

// MARK: - Tracking Loading Status

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
}
