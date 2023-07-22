//
//  CBMoviesModel.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//


import Foundation

// MARK: - CBMovies

struct CBMovies: Codable {
    let title, year, rated, released: String?
    let runtime, genre, director, writer: String?
    let actors, plot, language, country: String?
    let awards: String?
    let poster: String?
    let ratings: [Rating]
    let metascore, imdbRating, imdbVotes, imdbID: String?
    let type: TypeEnum?
    let dvd: DVD?
    let boxOffice, production: String?
    let website: DVD?
    let response: Response?
    let totalSeasons: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
        case totalSeasons
    }
}

enum DVD: String, Codable {
    case nA = "N/A"
    case the28Nov2000 = "28 Nov 2000"
    case the30Jan2007 = "30 Jan 2007"
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

enum Response: String, Codable {
    case responseTrue = "True"
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case series = "series"
}

// MARK: - Class Model

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
            print("Error loading JSON data: \(error)")
        }
        return nil
    }
    
    // In this we have the JSON data deserialized into the 'movie' instance of your model class.
    private func fetchMoviesFromData() -> [CBMovies]? {
        guard let jsonData = fetchDataFromJson() else { return nil }
        do {
            let decoder = JSONDecoder()
            let movies = try decoder.decode([CBMovies].self, from: jsonData)
            return movies
        } catch {
            fatalError("Error decoding JSON data: \(error)")
        }
    }
}
