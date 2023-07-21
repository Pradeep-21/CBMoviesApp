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
//    var allMovies: [C]?
    var array: [Model]?
    
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

        array = model
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

