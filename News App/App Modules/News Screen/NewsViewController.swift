//
//  NewsViewController.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import UIKit
import ExpandableLabel
import WebKit

struct Article {
    let object: NewEntity
    var state: Bool = true
}

class NewsViewController: UITableViewController {
    
    var newsPresenter: ViewToPresenterNewsProtocol?
    
    @IBOutlet weak var searchBar: UISearchBar!
    private var articles = [Article]()
    private var pageNumber = 1
    private var filteredData = [Article]()
    
    private let activityView = UIActivityIndicatorView(style: .medium)

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "News feed"
        //let titleAttributes = [ NSFontAttributeName: UIFont(name: "Chalkduster", size: 18.0)! ]
    
        //title = NSAttributedString(string: "News feed", attributes: titleAttributes)
        navigationController?.navigationBar.prefersLargeTitles = true
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()

        
        tableView.register(UINib(nibName: Nib.newsCell.rawValue, bundle: nil), forCellReuseIdentifier: Cell.news.rawValue)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        
        
        
        //let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        //footerView.addSubview(activityView)
        //activityView.center = self.tableView.tableFooterView!.center
        //self.view.addSubview(activityView)
        
        
        
        
        
        tableView.tableFooterView = activityView
        
        
        
        searchBar.delegate = self
        newsPresenter?.fetchNews(for: pageNumber)
        activityView.startAnimating()
    }
    
    @objc
    func refresh(_ sender: AnyObject) {
        pageNumber = 1
        articles.removeAll()
        filteredData.removeAll()
        tableView.reloadData()
        refreshControl?.endRefreshing()
        newsPresenter?.fetchNews(for: pageNumber)
        activityView.startAnimating()
    }
    
    // MARK: - Table Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = NewsCellRouter.createModule(tableView: tableView, indexPath: indexPath, article: filteredData[indexPath.row].object)
        cell.delegate = self
        cell.selectionStyle = .none
        
        cell.descriptionLabel.delegate = self
        cell.layoutIfNeeded()
        
        cell.descriptionLabel.shouldCollapse = true
        //cell.descriptionLabel.textReplacementType = currentSource.textReplacementType
        //cell.descriptionLabel.numberOfLines = 3
        cell.descriptionLabel.collapsed = articles[indexPath.row].state
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = filteredData.count - 1
        if let notSearching = searchBar.searchTextField.text?.isEmpty {
            if indexPath.row == lastElement && notSearching {
                pageNumber += 1
                if pageNumber < 8 {
                    activityView.startAnimating()
                    newsPresenter?.fetchNews(for: pageNumber)
                }
            }
        }
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func alertMessage(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
    }
        
}

// MARK: - ExpandableLabelDelegate (Pod)

extension NewsViewController: ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            articles[indexPath.row].state = false
        }
        tableView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            articles[indexPath.row].state = true
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
}

// MARK: - UISearchBarDelegate

extension NewsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? articles : articles.filter { (item: Article) -> Bool in
            print(item)
            return item.object.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

// MARK: - PresenterToViewNewsProtocol

extension NewsViewController: PresenterToViewNewsProtocol {
    
    func onFetchNewsResponseSuccess(for news: [NewEntity]) {
        self.articles += news.map { Article(object: $0) }
        self.filteredData = self.articles
        
        DispatchQueue.main.async { [weak self] in
            self?.activityView.stopAnimating()
            self?.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    func onFetchNewsResponseFailed(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.alertMessage(message: error.localizedDescription)
            self?.activityView.stopAnimating()
        }
    }
    
}

// MARK: - WebPreviewDelegate

extension NewsViewController: WebPreviewDelegate {
    
    func close(with error: Error) {
        guard let navigationController = navigationController else { fatalError("Empty UINavigationViewController to close Article.") }
        newsPresenter?.closeArticle(navigationController: navigationController)
        alertMessage(message: error.localizedDescription)
    }
    
}

// MARK: - CellNavigationDelegate

extension NewsViewController: CellNavigationDelegate {
    
    func redirect(indexPath: IndexPath) {
        guard let navigationController = navigationController else { fatalError("Empty UINavigationViewController to open Article.") }
        newsPresenter?.openArticle(url: articles[indexPath.row].object.url, from: self, navigationController: navigationController)
    }
    
}















//{
//    
//    let dateFormatter = DateFormatter()
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//    let date = dateFormatter.date(from: "2017-01-09T11:00:00.000Z")
//    print("date: \(date)")
//}

/*
 NEWS
 
 GET https://newsapi.org/v2/top-headlines?country=us&apiKey=505ae8aa1212428492c5cc29dc25c669
 
 
 // Using any free News API (e.g. https://newsapi.org) create an app which can display and filter news for last 7 days.
 
 
 Requirements:
 
 When application runs, user should see screen with news for last 24 hours only. When user reaches the end of current news list, then next news page for previous day should be downloaded and added to the bottom etc. till list contains 7-days news. In this case pagination should be disabled.
 
 
 Bonus points for:
 - a nice and interesting UI, animations;
 - using of data bases to store downloaded news.
 
 */
