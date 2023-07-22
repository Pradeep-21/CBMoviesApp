//
//  CBMoviesTableViewCell.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import UIKit
import AlamofireImage

class CBMoviesTableViewCell: UITableViewCell {

    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var language: UILabel!
    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var year: UILabel!
    
    // MARK: - Init Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Custom Methods
    
    func customUI(movie: CBMovies) {
        title.text = movie.title
        language.text = movie.language
        year.text = movie.year
        guard let imageUrlString = movie.poster, let imageUrl = URL(string: imageUrlString) else {
            // If imageURL is nil, set the default placeholder image.
            posterImageView.image = CBHelper.defaultImage()
            return
        }
        // Use AlamofireImage to fetch and set the image from the URL.
        posterImageView.af.setImage(withURL: imageUrl, placeholderImage: CBHelper.defaultImage())
        accessoryType = .disclosureIndicator
    }
    
}
