//
//  MoviesCategoryTableViewCell.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import UIKit

class MoviesCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak private var categoryNameLabel: UILabel!
    
    // MARK: - Init Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        expandButton.tintColor = .gray
        categoryNameLabel.textColor = .darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Customise Mehtods
    
    func customise(categoryText: String?, isSection: Bool = false) {
        if isSection {
            categoryNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            categoryNameLabel.text = categoryText
            expandButton.isHidden = false
        } else {
            expandButton.isHidden = true
            categoryNameLabel.text = "    - \(categoryText ?? "")"
            categoryNameLabel.font = UIFont.systemFont(ofSize: 17)
        }
    }
    
}
