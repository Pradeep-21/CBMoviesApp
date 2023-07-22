//
//  CBMoviesViewModel.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import Foundation

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
            years.append(movie.year ?? kDefaultString)
        }
        years = Array(Set(years))
        
        // Append the array of unique years in movies subCategory.
        movies.append(MovieSection(category: CBMovieCategory.year, subCategory: years, isOpened: false))
        
        // Usage for genres
        let uniqueGenresArray: [String] = CBHelper.extractUniqueValues(from: allMovies, keyPath: \.genre)
        movies.append(MovieSection(category: CBMovieCategory.genre, subCategory: uniqueGenresArray, isOpened: false))
        
        // Usage for directors
        let uniqueDirectorsArray: [String] = CBHelper.extractUniqueValues(from: allMovies, keyPath: \.director)
        movies.append(MovieSection(category: CBMovieCategory.directors, subCategory: uniqueDirectorsArray, isOpened: false))
        
        // Usage for actors
        let uniqueActorsArray: [String] = CBHelper.extractUniqueValues(from: allMovies, keyPath: \.actors)
        movies.append(MovieSection(category: CBMovieCategory.actors, subCategory: uniqueActorsArray, isOpened: false))
        
        // Append the All Movies section also.
        movies.append(MovieSection(category: CBMovieCategory.allMovies, subCategory: [], isOpened: false))
        
        movieSections.value = movies
    }
    
    // Filter the movies based on title/genre/actors, directors.
    func searchMovies(from searchText: String) {
        filteredMovies.value = allMovies?.filter({ movie in
            let isTitleMatch = CBHelper.isStringContainingValue(movie.title ?? kDefaultString, searchText)
            let isGenreMatch = CBHelper.isStringContainingValue(movie.genre ?? kDefaultString, searchText)
            let isActorMatch = CBHelper.isStringContainingValue(movie.actors ?? kDefaultString, searchText)
            let isDirectedMatch = CBHelper.isStringContainingValue(movie.director ?? kDefaultString, searchText)
            return (isTitleMatch || isGenreMatch || isActorMatch || isDirectedMatch)
        })
    }
    
    // Reset the value after the search completed.
    func resetSelectedSectionBool() {
        guard var tempArray = movieSections.value else { return }
        for index in 0..<tempArray.count {
            tempArray[index].isOpened = false
        }
        isSearch = false
        movieSections.value = tempArray
    }
}

