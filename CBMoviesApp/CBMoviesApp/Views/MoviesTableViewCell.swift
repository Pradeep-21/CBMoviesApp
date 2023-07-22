//
//  MoviesTableViewCell.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import UIKit
import AlamofireImage

protocol MoviesTableViewCellDelegate {
    func disTapMovie(movie: CBMovies)
}

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var language: UILabel!
    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var year: UILabel!
    
//    weak var delegate: MoviesTableViewCellDelegate?
    
    // MARK: - Init Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
    }
    
    // MARK: - Custom Methods
    
    func customUI(movie: CBMovies) {
        title.text = movie.title
        language.text = movie.language
        year.text = movie.year
        guard let imageUrlString = movie.poster, let imageUrl = URL(string: imageUrlString) else {
            return
        }
        posterImageView.af.setImage(withURL: imageUrl)
    }
    
}
