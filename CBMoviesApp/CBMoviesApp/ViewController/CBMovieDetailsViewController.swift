//
//  CBMovieDetailsViewController.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import UIKit
import AlamofireImage

class CBMovieDetailsViewController: UIViewController {

    @IBOutlet weak private var castCrew: UILabel!
    @IBOutlet weak private var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var ratingSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var plot: UILabel!
    @IBOutlet weak private var genre: UILabel!
    @IBOutlet weak private var releasedDate: UILabel!
    @IBOutlet weak private var movieTitle: UILabel!
    @IBOutlet weak private var posterImageView: UIImageView!
    
    var movie: CBMovies?
    var movieImage: UIImage?
    var viewModel = CBMoviesDetailViewModel()

    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseUI()
        updateRatingValue()
        ratingSegmentedControl.selectedSegmentIndex = 0
    }

    // MARK: - Action Methods
    
    @IBAction func ratingSourceChanged(_ sender: UISegmentedControl) {
        ratingSegmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
    }
    
    // MARK: - Custom methods
    
    private func customiseUI() {
        movieTitle.text = movie?.title
        releasedDate.text = movie?.released
        genre.text = movie?.genre
        plot.text = movie?.plot
    
        // Fetch the cast and crew information and split it into an array of substrings
        let castAndCrewString = viewModel.fetchCastAndCrew(movie: movie).joined(separator: ", ")
        castCrew.text = castAndCrewString
        
        // Get plot text height based on content, size and width. Then change the content view height.
        let height = CBHelper.getExactLabelHeight(for: movie?.plot ?? "", with: UIFont.systemFont(ofSize: 17), andLabelWidth: UIScreen.main.bounds.width - 20)
        contentViewHeightConstraint.constant = height - 80
        
        // Update the poster Image
        guard let imageUrlString = movie?.poster, let imageUrl = URL(string: imageUrlString) else {
            // If imageURL is nil, set the default placeholder image.
            posterImageView.image = CBHelper.defaultImage()
            return
        }
        // Use AlamofireImage to fetch and set the image from the URL.
        posterImageView.af.setImage(withURL: imageUrl, placeholderImage: CBHelper.defaultImage())
    }
    
    private func updateRatingValue() {
        ratingSegmentedControl.removeAllSegments()
        guard let ratings = movie?.ratings else { return }
        for (index, rating) in ratings.enumerated() {
            ratingSegmentedControl.insertSegment(withTitle: rating.value, at: index, animated: false)
        }
    }
}
