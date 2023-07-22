//
//  CBMoviesDetailViewModel.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import Foundation

class CBMoviesDetailViewModel {
    func fetchCastAndCrew(movie: CBMovies?) -> [String] {
        guard let movie else { return []}
        // Usage for actors
        let uniqueActorsArray: [String] = CBHelper.extractUniqueValues(from: [movie], keyPath: \.actors)
        print(uniqueActorsArray)
        
        // Usage for directors
        let uniqueDirectorsArray: [String] = CBHelper.extractUniqueValues(from: [movie], keyPath: \.director)
        print(uniqueDirectorsArray)
        
        // Usage for directors
        let uniqueWriterArray: [String] = CBHelper.extractUniqueValues(from: [movie], keyPath: \.writer)
        print(uniqueWriterArray)
        return  uniqueDirectorsArray + uniqueActorsArray + uniqueWriterArray
    }
}
