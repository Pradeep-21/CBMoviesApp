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
            case .actor:
                return CBHelper.isStringContainingValue(movie.actors ?? "", subCategory ?? "")
            case .genre:
                return CBHelper.isStringContainingValue(movie.genre ?? "", subCategory ?? "")
            case .year:
                return CBHelper.isStringContainingValue(movie.year ?? "", subCategory ?? "")
            case .directer:
                return CBHelper.isStringContainingValue(movie.director ?? "", subCategory ?? "")
            case .none: break
            case .some(_): break
            }
            return false
        })
    }
}
