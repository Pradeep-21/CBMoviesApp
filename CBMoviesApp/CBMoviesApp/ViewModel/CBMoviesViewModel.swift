//
//  CBMoviesViewModel.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import Foundation

protocol CBMoviesModelProtocol {
    func getMoviesDetails() -> [CBMovies]
}

class CBMoviesViewModel {
    
    var model: CBMoviesModelProtocol
    var moviesArray: [CBMovies]?
    
    func getMoviesDetails() -> [CBMovies] {
        
    }
    
}
