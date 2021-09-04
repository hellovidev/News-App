//
//  NewsTableViewCell.swift
//  News App
//
//  Created by Sergei Romanchuk on 04.09.2021.
//

import UIKit
import ExpandableLabel
import  Combine

class NewsTableViewCell: UITableViewCell {
    
    var newsCellPresenter: ViewToPresenterNewsCellProtocol?
    
    private let networkService: NetworkService = .init()

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: ExpandableLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        descriptionLabel.numberOfLines = 3
        descriptionLabel.collapsed = true
        descriptionLabel.collapsedAttributedLink = NSAttributedString(string: "Show More", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePreview.image = UIImage(named: "ImagePlaceholder")
        imagePreview.layer.cornerRadius = 25
        imagePreview.layer.borderWidth = 2
        imagePreview.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        titleLabel.text = "No title"
        descriptionLabel.text = "No description"
        descriptionLabel.numberOfLines = 3
        descriptionLabel.collapsed = true
        descriptionLabel.collapsedAttributedLink = NSAttributedString(string: "Show more", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
        
        imagePreview.image = nil
        imagePreview.alpha = 0.0
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }
    
//    func loadImage(url: String) {
//        newsCellPresenter?.fetchImageData(endpoint: url)
//    }
    
    
    
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?


    public func configure(with article: NewEntity) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        cancellable = loadImage(for: article).sink { [unowned self] image in self.showImage(image: image) }
    }

    private func showImage(image: UIImage?) {
        imagePreview.alpha = 0.0
        animator?.stopAnimation(false)
        imagePreview.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.imagePreview.alpha = 1.0
        })
    }

    private func loadImage(for article: NewEntity) -> AnyPublisher<UIImage?, Never> {
        return Just(article.urlToImage)
            .flatMap(
                { poster -> AnyPublisher<UIImage?, Never> in
                    guard let endpoint = article.urlToImage else { abort() }
                    guard let url = URL(string: endpoint) else { abort() }
                    return ImageLoader.shared.loadImage(from: url)
                }
            )
            .eraseToAnyPublisher()
    }
    
}

// MARK: - PresenterToViewNewsCellProtocol

extension NewsTableViewCell: PresenterToViewNewsCellProtocol {
    
    func onFetchImageDataResponseSuccess(for imageData: Data) {
        DispatchQueue.main.async {
            self.imagePreview.image = UIImage(data: imageData)
            self.imagePreview.layer.cornerRadius = 25
            self.imagePreview.layer.borderWidth = 2
            self.imagePreview.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    func onFetchImageDataResponseFailed(_ error: Error) {
        print("Error: \(error)")
    }
    
}
