//
//  CBEnum.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import UIKit

enum AppStoryboards : String {
   case Main = "Main"
    
   var instance: UIStoryboard {
      return UIStoryboard(name: self.rawValue, bundle: nil)
   }
}

enum CBMovieCategory: String, CaseIterable {
    case year = "Year"
    case genre = "Genre"
    case directors = "Directors"
    case actors = "Actors"
    case allMovies = "All Movies"
}
