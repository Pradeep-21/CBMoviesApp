//
//  CBMovieDetailsViewController.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import UIKit

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
    }

    // MARK: - Custom methods
    
    private func customiseUI() {
        movieTitle.text = movie?.title
        releasedDate.text = movie?.released
        genre.text = movie?.genre
        posterImageView.image = movieImage
    }
}
