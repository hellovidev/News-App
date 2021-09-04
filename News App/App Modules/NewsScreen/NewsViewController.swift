//
//  NewsViewController.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import UIKit
import ExpandableLabel

class NewsViewController: UITableViewController {

    var newsPresenter: ViewToPresenterNewsProtocol?
    
    private var news = [NewEntity]()
    private var states = [Bool]()
    private var pageNumber = 1
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        title = "Hot news"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        //tableView.addSubview(refreshControl!) // not required when using UITableViewController
        tableView.refreshControl = refreshControl
        
        //tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: Cell.news.rawValue)
        tableView.register(UINib(nibName: Nib.newsCell.rawValue, bundle: nil), forCellReuseIdentifier: Cell.news.rawValue)
        tableView.rowHeight = UITableView.automaticDimension
        
        //let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        var activityView = UIActivityIndicatorView(style: .medium)

        //footerView.addSubview(activityView)
        //activityView.center = self.tableView.tableFooterView!.center
        //self.view.addSubview(activityView)
        
        tableView.tableFooterView = activityView
        activityView.startAnimating()

        newsPresenter?.fetchNews(for: pageNumber)
    }
    


    @objc func refresh(_ sender: AnyObject) {
        pageNumber = 1
//        self.refreshControl?.endRefreshing()
        newsPresenter?.fetchNews(for: pageNumber)
       // Code to refresh table view
    }
    
    // MARK: - Table Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Table Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.news.rawValue, for: indexPath) as? NewsTableViewCell else {
//            fatalError("Unable to dequeue contact cell.")
//        }
        let cell = NewsCellRouter.createModule(tableView: tableView, indexPath: indexPath)
        
        cell.selectionStyle = .none

        cell.configure(with: news[indexPath.row])
//        cell.titleLabel.text = news[indexPath.row].title
//        cell.descriptionLabel.text = news[indexPath.row].description
        cell.descriptionLabel.delegate = self
        cell.layoutIfNeeded()
        
        cell.descriptionLabel.shouldCollapse = true
        //cell.descriptionLabel.textReplacementType = currentSource.textReplacementType
        //cell.descriptionLabel.numberOfLines = 3
        cell.descriptionLabel.collapsed = states[indexPath.row]
//
//        if let imageEndpoint = news[indexPath.row].urlToImage {
//            cell.loadImage(url: imageEndpoint)
//        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = news.count - 1
        if indexPath.row == lastElement {
            pageNumber += 1
            if pageNumber < 8 {
                newsPresenter?.fetchNews(for: pageNumber)
            }
        }
    }
    
}

extension NewsViewController: ExpandableLabelDelegate {
    func willExpandLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = false
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//            }
        }
        tableView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = true
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }

    
}

// MARK: - Extension Feed View Controller For PresenterToViewProtocol
extension NewsViewController: PresenterToViewNewsProtocol {
//    func onFetchImageDataRequestSuccess(for imageData: Data) {
//        //
//    }
//
//    func onFetchImageDataRequestFailed(_ error: Error) {
//        //
//    }
    
    func onFetchNewsResponseSuccess(for news: [NewEntity]) {
        states += [Bool](repeating: true, count: news.count)
        self.news += news
        
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func onFetchNewsResponseFailed(_ error: Error) {
        print("Error: \(error)")
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

User should be able to refresh news list by pull-to-refresh. Days counter should be also reseted.

Also search bar should be added at top of main screen. It should allow user to filter currently downloaded news by news title.

Bonus points for:
- a nice and interesting UI, animations;
- using of data bases to store downloaded news.

*/




