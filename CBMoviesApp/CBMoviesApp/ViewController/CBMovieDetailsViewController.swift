//
//  CBMovieDetailsViewController.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import UIKit
import AlamofireImage

class CBMovieDetailsViewController: UIViewController {

    @IBOutlet weak private var plot: UILabel!
    @IBOutlet weak private var genre: UILabel!
    @IBOutlet weak private var releasedDate: UILabel!
    @IBOutlet weak private var movieTitle: UILabel!
    @IBOutlet weak private var posterImageView: UIImageView!
    
    var movie: CBMovies?
    var movieImage: UIImage?

    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseUI()
//        title =
    }

    // MARK: - Custom methods
    
    private func customiseUI() {
        movieTitle.text = movie?.title
        releasedDate.text = movie?.released
        genre.text = movie?.genre
        plot.text = movie?.plot
        
        guard let imageUrlString = movie?.poster, let imageUrl = URL(string: imageUrlString) else {
            // If imageURL is nil, set the default placeholder image.
            posterImageView.image = CBHelper.defaultImage()
            return
        }
        // Use AlamofireImage to fetch and set the image from the URL.
        posterImageView.af.setImage(withURL: imageUrl, placeholderImage: CBHelper.defaultImage())
    }
}
