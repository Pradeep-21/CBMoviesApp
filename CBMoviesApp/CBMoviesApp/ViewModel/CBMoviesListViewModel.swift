//
//  CBMoviesListViewModel.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import Foundation

class CBMoviesListViewModel {
    var searchedMovies: [CBMovies]?
    
    func fetchSubMovieList(from movies: [CBMovies]?, with selectedText: String?, text: String?) {
        searchedMovies = movies?.filter({ movie in
            switch selectedText {
            case "Actor":
                return CBHelper.isStringContainingValue(movie.actors ?? "", text ?? "")
            case "Genre":
                return CBHelper.isStringContainingValue(movie.genre ?? "", text ?? "")
            case "Year":
                return CBHelper.isStringContainingValue(movie.year ?? "", text ?? "")
            case "Directer":
                return CBHelper.isStringContainingValue(movie.director ?? "", text ?? "")
            case .none: break
            case .some(_): break
            }
            return false
        })
    }
}
