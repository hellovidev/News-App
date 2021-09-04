//
//  NewsTableViewCell.swift
//  News App
//
//  Created by Sergei Romanchuk on 04.09.2021.
//

import UIKit
import ExpandableLabel

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: ExpandableLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        descriptionLabel.numberOfLines = 3
        descriptionLabel.collapsed = true
        descriptionLabel.collapsedAttributedLink = NSAttributedString(string: "Show more", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePreview.image = UIImage(named: "ImagePlaceholder")
        titleLabel.text = "No title"
        descriptionLabel.text = "No description"
    }
}
