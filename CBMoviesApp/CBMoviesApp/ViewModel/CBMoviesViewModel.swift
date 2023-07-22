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

struct Model {
    var category: String?
    var subCategory: [String]?
    var isOpened: Bool?
}

class CBMoviesViewModel {
    
    var model: CBMoviesModelProtocol?
    var moviesArray: [CBMovies]?
    var array: [Model]?
    var searchedMovies: [CBMovies]?
    var isSearch: Bool = false
    var isExpand: Bool = false
    
    init(model: CBMoviesModelProtocol) {
        self.model = model
    }
    
    func getMoviesDetails() {
        moviesArray = model?.getMoviesDetails()
        chekc()
    }
    
    private func chekc() {
        
        var model = [Model]()
        guard let moviesArray else { return }
        // Create a dictionary to hold the sections
        
        var years = [String]()
        for movie in moviesArray {
            years.append(movie.year ?? "")
        }
        years = Array(Set(years))
        
        model.append(Model(category: CBMovieCategory.year.rawValue, subCategory: years, isOpened: false))
        
        // Usage for actors
        let uniqueActorsArray: [String] = extractUniqueValues(from: moviesArray, keyPath: \.actors)
        print(uniqueActorsArray)
        model.append(Model(category: CBMovieCategory.actor.rawValue, subCategory: uniqueActorsArray, isOpened: false))

        // Usage for directors
        let uniqueDirectorsArray: [String] = extractUniqueValues(from: moviesArray, keyPath: \.director)
        print(uniqueDirectorsArray)
        model.append(Model(category: CBMovieCategory.directer.rawValue, subCategory: uniqueDirectorsArray, isOpened: false))

        // Usage for genres
        let uniqueGenresArray: [String] = extractUniqueValues(from: moviesArray, keyPath: \.genre)
        print(uniqueGenresArray)
        model.append(Model(category: CBMovieCategory.genre.rawValue, subCategory: uniqueGenresArray, isOpened: false))

        model.append(Model(category: CBMovieCategory.allMovies.rawValue, subCategory: [], isOpened: false))
        
        array = model
    }
    
    func searchMovies(from searchText: String) {
        searchedMovies = moviesArray?.filter({ movie in
            let isTitleMatch = isStringContainingValue(movie.title ?? "", searchText)
            let isGenreMatch = isStringContainingValue(movie.genre ?? "", searchText)
            let isActorMatch = isStringContainingValue(movie.actors ?? "", searchText)
            let isDirectedMatch = isStringContainingValue(movie.director ?? "", searchText)
            return (isTitleMatch || isGenreMatch || isActorMatch || isDirectedMatch)
        })
    }
    
    func isStringContainingValue(_ targetString: String, _ desiredValue: String) -> Bool {
        let components = targetString.components(separatedBy: ",")
        return components.contains { $0.range(of: desiredValue, options: .caseInsensitive) != nil }
    }
}


// Generic function to extract unique strings from comma-separated strings
func extractUniqueValues<T>(from items: [CBMovies], keyPath: KeyPath<CBMovies, String?>) -> [T] where T: Hashable, T: LosslessStringConvertible {
    var uniqueValues = Set<String>()
    
    for movie in items {
        if let value = movie[keyPath: keyPath] {
            let components = value.split(separator: ",")
            uniqueValues.formUnion(components.lazy.map { $0.trimmingCharacters(in: .whitespaces) })
        }
    }
    
    return uniqueValues.compactMap { T($0) }
}

