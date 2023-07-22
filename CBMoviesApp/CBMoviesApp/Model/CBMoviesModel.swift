//
//  CBMoviesModel.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//


import Foundation

// MARK: - CBMovies

struct CBMovies: Codable {
    let title, year, released: String?
    let genre, director, writer: String?
    let actors, plot, language: String?
    let poster: String?
    let ratings: [Rating]

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case released = "Released"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case poster = "Poster"
        case ratings = "Ratings"
    }
}

// MARK: - Rating

struct Rating: Codable {
    let source: Source
    let value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

enum Source: String, Codable {
    case internetMovieDatabase = "Internet Movie Database"
    case metacritic = "Metacritic"
    case rottenTomatoes = "Rotten Tomatoes"
}

// MARK: - Movies Section Model

struct MovieSection {
    var category: CBMovieCategory?
    var subCategory: [String]?
    var isOpened: Bool?
}

// MARK: - Class Methods & Properties

protocol CBMoviesModelProtocol {
    func getMoviesDetails() -> [CBMovies]?
}

class CBMoviesModel: CBMoviesModelProtocol {
    
    func getMoviesDetails() -> [CBMovies]? {
        return fetchMoviesFromData()
    }
 
    private func fetchDataFromJson () -> Data? {
        guard let path = Bundle.main.path(forResource: "Movies", ofType: "json") else {
            print("🥶🥶 Movies.json not found in the app bundle.")
            return nil
        }

        do {
            let url = URL(fileURLWithPath: path)
            let jsonData = try Data(contentsOf: url)
            return jsonData
        } catch {
            print("🥶🥶 Error loading JSON data: \(error)")
        }
        return nil
    }
    
    // In this we have the JSON data deserialised into the 'movie' instance of your model class.
    private func fetchMoviesFromData() -> [CBMovies]? {
        guard let jsonData = fetchDataFromJson() else { return nil }
        do {
            let decoder = JSONDecoder()
            let movies = try decoder.decode([CBMovies].self, from: jsonData)
            return movies
        } catch {
            print("🥶🥶Error decoding JSON data: \(error)")
            return nil
        }
    }
}
