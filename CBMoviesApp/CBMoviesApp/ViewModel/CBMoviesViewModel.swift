//
//  CBMoviesViewModel.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import Foundation

protocol CBMoviesModelProtocol {
    func getMoviesDetails() -> [CBMovies]?
}

struct MovieSection {
    var category: String?
    var subCategory: [String]?
    var isOpened: Bool?
}

class CBMoviesViewModel {
    var model: CBMoviesModelProtocol?
    
    var allMovies: [CBMovies]?
    var movieSections = CCObservable<[MovieSection]>()
    var filteredMovies = CCObservable<[CBMovies]>()
    var isSearch: Bool = false
    
    // MARK: - Init Methods
    
    init(model: CBMoviesModelProtocol) {
        self.model = model
    }
    
    // MARK: - Custom Methods
    
    func getMoviesDetails() {
        allMovies = model?.getMoviesDetails()
        updateMovieSectionDetails()
    }
    
    private func updateMovieSectionDetails() {
        var movies = [MovieSection]()
        guard let allMovies else { return }
        
        // Usage of years.
        var years = [String]()
        
        allMovies.forEach { movie in
            years.append(movie.year ?? "")
        }
        years = Array(Set(years))
        
        // Append the array of unique years in movies subCategory.
        movies.append(MovieSection(category: CBMovieCategory.year.rawValue, subCategory: years, isOpened: false))
        
        // Usage for actors
        let uniqueActorsArray: [String] = CBHelper.extractUniqueValues(from: allMovies, keyPath: \.actors)
        print(uniqueActorsArray)
        movies.append(MovieSection(category: CBMovieCategory.actor.rawValue, subCategory: uniqueActorsArray, isOpened: false))

        // Usage for directors
        let uniqueDirectorsArray: [String] = CBHelper.extractUniqueValues(from: allMovies, keyPath: \.director)
        print(uniqueDirectorsArray)
        movies.append(MovieSection(category: CBMovieCategory.directer.rawValue, subCategory: uniqueDirectorsArray, isOpened: false))

        // Usage for genres
        let uniqueGenresArray: [String] = CBHelper.extractUniqueValues(from: allMovies, keyPath: \.genre)
        print(uniqueGenresArray)
        movies.append(MovieSection(category: CBMovieCategory.genre.rawValue, subCategory: uniqueGenresArray, isOpened: false))

        // Append the All Movies section also.
        movies.append(MovieSection(category: CBMovieCategory.allMovies.rawValue, subCategory: [], isOpened: false))
        
        movieSections.value = movies
    }
    
    func searchMovies(from searchText: String) {
        filteredMovies.value = allMovies?.filter({ movie in
            let isTitleMatch = CBHelper.isStringContainingValue(movie.title ?? "", searchText)
            let isGenreMatch = CBHelper.isStringContainingValue(movie.genre ?? "", searchText)
            let isActorMatch = CBHelper.isStringContainingValue(movie.actors ?? "", searchText)
            let isDirectedMatch = CBHelper.isStringContainingValue(movie.director ?? "", searchText)
            return (isTitleMatch || isGenreMatch || isActorMatch || isDirectedMatch)
        })
    }
}

