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
    var states : Array<Bool>!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set title to navigation view
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register custom table view cell
        tableView.register(UINib(nibName: Nib.newsCell.rawValue, bundle: nil), forCellReuseIdentifier: Cell.news.rawValue)
        
        newsPresenter?.fetchNews()
        tableView.rowHeight = UITableView.automaticDimension

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table Delegate Methods
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell
//        (tableView.cellForRow(at: indexPath) as? NewsTableViewCell)?.descriptionLabel.numberOfLines = (tableView.cellForRow(at: indexPath) as? NewsTableViewCell)?.descriptionLabel.numberOfLines == 0 ? 3 : 0
//        UIView.animate(withDuration: 0.5) {
//            (tableView.cellForRow(at: indexPath) as? NewsTableViewCell)?.descriptionLabel.superview?.layoutIfNeeded()
//        }
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//
//        //tableView.reloadData()
//        //tableView.deselectRow(at: indexPath, animated: true)
//    }


    
    // MARK: - Table Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        states = [Bool](repeating: true, count: news.count)
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.news.rawValue) as? NewsTableViewCell else {
        //dequeueReusableCell(withIdentifier: Cell.news.rawValue, for: indexPath) as? NewsTableViewCell else {
            fatalError("Unable to dequeue contact cell.")
        }
        
        //cell.delegate = self
        cell.selectionStyle = .none
        //cell.showMoreButton.tag = indexPath.row
        //cell.btnMore.tag = indexPath.row
        cell.titleLabel.text = news[indexPath.row].title
        cell.descriptionLabel.text = news[indexPath.row].description
        
        cell.descriptionLabel.delegate = self
        
        
        cell.layoutIfNeeded()
        
        cell.descriptionLabel.shouldCollapse = true
        //cell.descriptionLabel.textReplacementType = currentSource.textReplacementType
        //cell.descriptionLabel.numberOfLines = currentSource.numberOfLines
        //cell.descriptionLabel.collapsed = states[indexPath.row]
        
        //var attributes = [NSAttributedString.Key: Any]()
        //attributes[.foregroundColor] = UIColor.blue

        //cell.descriptionLabel.attributedReadMoreText = NSAttributedString(string: "...Show more", attributes: attributes)
        //cell.descriptionLabel.attributedReadLessText = NSAttributedString(string: "...Hide", attributes: attributes)

        if let imageEndpoint = news[indexPath.row].urlToImage {
            let ns = NetworkService()
            ns.loadImageByURL(endpoint: imageEndpoint) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.imagePreview.image = UIImage(data: data)
                        cell.imagePreview.layer.cornerRadius = 25
                        cell.imagePreview.layer.borderWidth = 2
                        cell.imagePreview.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                    cell.imagePreview.image = UIImage(named: "ImagePlaceholder")
                    cell.imagePreview.layer.cornerRadius = 25
                    cell.imagePreview.layer.borderWidth = 2
                    cell.imagePreview.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                    }
                    print("Error: \(error)")
                }
                
            }
        }

        return cell
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
    func onFetchImageDataRequestSuccess(for imageData: Data) {
        //
    }
    
    func onFetchImageDataRequestFailed(_ error: Error) {
        //
    }
    
    func onFetchNewsResponseSuccess(for news: [NewEntity]) {
        self.news = news
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func onFetchNewsResponseFailed(_ error: Error) {
        print("Error: \(error)")
    }
    
}
/*
NEWS
 
 GET https://newsapi.org/v2/top-headlines?country=us&apiKey=505ae8aa1212428492c5cc29dc25c669

 
 // Using any free News API (e.g. https://newsapi.org) create an app which can display and filter news for last 7 days.

 
Requirements:

+++ 1. The app should look like single-view application which displays list/collection of news.
2. Each cell should contain at least preview image (if no image received, use fixed placeholder instead), title and short description (1-3 lines of text. If description is more than 3 lines, add blue "Show More" text to the end of description)

 /// If description is more than 3 lines, add blue "Show More" text to the end of description
 
 
When application runs, user should see screen with news for last 24 hours only. When user reaches the end of current news list, then next news page for previous day should be downloaded and added to the bottom etc. till list contains 7-days news. In this case pagination should be disabled.

User should be able to refresh news list by pull-to-refresh. Days counter should be also reseted.

Also search bar should be added at top of main screen. It should allow user to filter currently downloaded news by news title.

Bonus points for:
- a nice and interesting UI, animations;
- using of data bases to store downloaded news.

You can use any libraries/frameworks except frameworks provided by News API provider. As bonus points

Your solution should include a README explaining how to set up and run the project.


*/






//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    // Register custom table view cell
//    tableView.register(UINib(nibName: Identifier.Nib.contactCell.rawValue, bundle: nil), forCellReuseIdentifier: Identifier.contactCellIdentifier.rawValue)
//
//    // Fetch contacts from phone storage
//    contactsModel.fetchPhoneContacts { [weak self] result in
//        switch result {
//        case .success(let data):
//            self?.contacts = data
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//    }
//}
