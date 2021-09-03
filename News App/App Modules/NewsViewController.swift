//
//  NewsViewController.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import UIKit

class NewsViewController: UITableViewController {
    
    var newsPresenter: ViewToPresenterNewsProtocol?
    private var news = [NewEntity]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set title to navigation view
        self.title = "News"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsPresenter?.fetchNewsFromServer()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: - Table Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.news.rawValue, for: indexPath) as? UITableViewCell else {
            fatalError("Unable to dequeue contact cell.")
        }
        
        cell.textLabel?.text = news[indexPath.row].title
        
//        // Check full name availability
//        if contacts[indexPath.row].givenName.isEmpty && contacts[indexPath.row].middleName.isEmpty && contacts[indexPath.row].familyName.isEmpty {
//            cell.contactFullName.text = "None"
//        } else {
//            cell.contactFullName.text = "\(contacts[indexPath.row].givenName) \(contacts[indexPath.row].middleName.isEmpty ? "" : contacts[indexPath.row].middleName + " ")\(contacts[indexPath.row].familyName)"
//        }
//
//
//        // Check phone number availability
//        if contacts[indexPath.row].phoneNumbers.isEmpty {
//            cell.contactPhoneNumber.text = "None"
//        } else {
//            cell.contactPhoneNumber.text = contacts[indexPath.row].phoneNumbers.first?.value.stringValue
//        }
//
        return cell
    }

}

// MARK: - Extension Feed View Controller For PresenterToViewProtocol
extension NewsViewController: PresenterToViewNewsProtocol {
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

The app should look like single-view application which displays list/collection of news.
Each cell should contain at least preview image (if no image received, use fixed placeholder instead), title and short description (1-3 lines of text. If description is more than 3 lines, add blue "Show More" text to the end of description)

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
