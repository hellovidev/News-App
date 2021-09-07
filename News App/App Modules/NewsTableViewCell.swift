//
//  NewsTableViewCell.swift
//  News App
//
//  Created by Sergei Romanchuk on 04.09.2021.
//

import UIKit
import ExpandableLabel
import Combine

class NewsTableViewCell: UITableViewCell {
    
    var newsCellPresenter: ViewToPresenterNewsCellProtocol?
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: ExpandableLabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateContainer: UIView!
    
    weak var delegate: CellNavigationDelegate?
    var indexPath: IndexPath?
    
    private var animator: UIViewPropertyAnimator?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func redirect(_ sender: UIButton) {
        guard let indexPath = indexPath, let delegate = delegate else { return }
        newsCellPresenter?.showWebPreview(indexPath: indexPath, delegate: delegate)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = "No title"
        
        imagePreview.image = UIImage(named: "ImagePlaceholder")
        imagePreview.alpha = 0.0
        animator?.stopAnimation(true)
        
        
        descriptionLabel.text = "No description"
        descriptionLabel.numberOfLines = 3
        descriptionLabel.collapsed = true
        descriptionLabel.collapsedAttributedLink = NSAttributedString(string: "Show More", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.object.title
        
        descriptionLabel.numberOfLines = 3
        descriptionLabel.collapsed = true
        descriptionLabel.collapsedAttributedLink = NSAttributedString(string: "Show More", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
        descriptionLabel.collapsed = article.state
        descriptionLabel.text = article.object.description
        
        dateLabel.text = formatteData(article.object.publishedAt)
        dateContainer.layer.cornerRadius = 10
        
        newsCellPresenter?.fetchImageData(endpoint: article.object.urlToImage ?? "")
    }
    
    private func formatteData(_ value: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from: value)
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        guard let date = date else { return "No date" }
        let result = dateFormatter.string(from: date)
        return result
    }
    
    private func showImage(imageData: Data) {
        imagePreview.alpha = 0.0
        animator?.fractionComplete = 0.25
        animator?.stopAnimation(true)
        animator?.finishAnimation(at: .current)
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0.7)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.3)
        let whiteColor = UIColor.white
        
        gradient.colors = [
            whiteColor.withAlphaComponent(0.0).cgColor,
            whiteColor.withAlphaComponent(0.5).cgColor,
            whiteColor.withAlphaComponent(1.0).cgColor
        ]
        
        gradient.locations = [
            NSNumber(value: 0.0),
            NSNumber(value: 0.5),
            NSNumber(value: 1.0)
        ]
        
        gradient.frame = imagePreview.bounds
        imagePreview.layer.mask = gradient
        
        imagePreview.image = UIImage(data: imageData)
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.imagePreview.alpha = 1.0
        })
    }
    
}

// MARK: - PresenterToViewNewsCellProtocol

extension NewsTableViewCell: PresenterToViewNewsCellProtocol {
    
    func onFetchImageDataResponseSuccess(for imageData: Data) {
        DispatchQueue.main.async {
            self.showImage(imageData: imageData)
        }
    }
    
    func onFetchImageDataResponseFailed(_ error: Error) {
        print("Error: \(error)")
    }
    
}
