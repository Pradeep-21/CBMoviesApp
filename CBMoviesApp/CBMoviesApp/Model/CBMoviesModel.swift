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


enum CBMovieCategory: String {
    case Year = "Year"
    case 
}

typealias Welcome = [CBMovies]

func chekc() {
    let movies = [CBMovies]()
    
    // Create a dictionary to hold the sections
    var sections: [String: [CBMovies]] = [:]
    
    // Group the movies by the desired key (e.g., genre, director, type)
    sections = Dictionary(grouping: movies, by: { $0.genre ?? "" }) // Replace "genre" with the desired key
    
    var years: [String?] = ["2000", "2002"]
    
    for movie in movies {
        years.append(movie.year)
    }
    var moviewgeners: [String?] = []
    for movie in movies {
        let gener = movie.genre
        let geners = gener?.split(separator: ",")
        for g in geners {
            moviewgeners.append(g)
        }
    }
    
    Set(years)
    
    var sectionArray: [Section] = []

    for (key, value) in sections {
        sectionArray.append(Section(title: key, items: value))
    }

}

struct Section {
    let title: String?
    let items: [CBMovies]?
}


class CBMoviesModel: CBMoviesModelProtocol {
    
    func getMoviesDetails() -> [CBMovies] {
        
    }
 
    private func fetchDataFromJson () -> Data? {
        guard let path = Bundle.main.path(forResource: "Movies", ofType: "json") else {
            fatalError("Movies.json not found in the app bundle.")
        }

        do {
            let url = URL(fileURLWithPath: path)
            let jsonData = try Data(contentsOf: url)
            // Now, you have the JSON data in the 'jsonData' variable.
            return jsonData
        } catch {
            fatalError("Error loading JSON data: \(error)")
        }

    }
    
    private func fetchMoviesFromData() -> [CBMovies]? {
        guard let jsonData = fetchDataFromJson() else { return nil }
        do {
            let decoder = JSONDecoder()
            let movies = try decoder.decode([CBMovies].self, from: jsonData)
            // Now, you have the JSON data deserialized into the 'movie' instance of your model class.
            print("Movie Title: \(movies.first?.title)")
            print("Year: \(movies.first?.year)")
            print("Director: \(movies.first?.director)")
            // Access other properties as needed.
            return movies
        } catch {
            fatalError("Error decoding JSON data: \(error)")
        }
    }
    
}
