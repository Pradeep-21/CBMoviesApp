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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customise(categoryText: String?) {
        categoryNameLabel.text = categoryText
    }
    
}
