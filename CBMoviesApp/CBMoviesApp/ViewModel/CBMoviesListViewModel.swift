//
//  CBMoviesListViewModel.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import Foundation

class CBMoviesListViewModel {
    var filteredMovies = CCObservable<[CBMovies]>()
    
    func fetchSubMovieList(from movies: [CBMovies]?, with selectedText: CBMovieCategory?, and subCategory: String?) {
        filteredMovies.value = movies?.filter({ movie in
            switch selectedText {
            case .actors:
                return CBHelper.isStringContainingValue(movie.actors ?? kDefaultString, subCategory ?? kDefaultString)
            case .genre:
                return CBHelper.isStringContainingValue(movie.genre ?? kDefaultString, subCategory ?? kDefaultString)
            case .year:
                return CBHelper.isStringContainingValue(movie.year ?? kDefaultString, subCategory ?? kDefaultString)
            case .directors:
                return CBHelper.isStringContainingValue(movie.director ?? kDefaultString, subCategory ?? kDefaultString)
            case .none: break
            case .some(_): break
            }
            return false
        })
    }
}
