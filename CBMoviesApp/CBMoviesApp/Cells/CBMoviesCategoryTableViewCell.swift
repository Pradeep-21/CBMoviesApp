//
//  CBMoviesCategoryTableViewCell.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import UIKit

class CBMoviesCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak private var expandButton: UIButton!
    @IBOutlet weak private var categoryNameLabel: UILabel!
    
    // MARK: - Init Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        expandButton.tintColor = .gray
        categoryNameLabel.textColor = .darkGray
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Customise Mehtods
    
    func customise(movieSection: MovieSection?, index: Int, isSection: Bool = false) {
        if isSection {
            categoryNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            categoryNameLabel.text = movieSection?.category?.rawValue
            expandButton.isHidden = false
            updateExpandButtonImage(isExpand: movieSection?.isOpened)
            accessoryType = .none
        } else {
            expandButton.isHidden = true
            categoryNameLabel.text = "    - \(movieSection?.subCategory?[index] ?? kDefaultString)"
            categoryNameLabel.font = UIFont.systemFont(ofSize: 17)
            accessoryType = .disclosureIndicator
        }
    }
    
    private func updateExpandButtonImage(isExpand: Bool?) {
        expandButton.setImage(UIImage(systemName: isExpand == true ? kUpArrowImageString : kDownArrowImageString), for: .normal)
    }
}
