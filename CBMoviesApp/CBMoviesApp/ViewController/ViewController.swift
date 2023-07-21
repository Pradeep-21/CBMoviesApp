//
//  ViewController.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var moviesTypesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        json()
    }
    
    private func registerNibCell() {
        moviesTypesTableView.register(UINib(nibName: String(describing: MoviesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoviesTableViewCell.self))
        moviesTypesTableView.delegate = self
        moviesTypesTableView.dataSource = self
    }

    func test () -> Data? {
        guard let path = Bundle.main.path(forResource: "Movies", ofType: "json") else {
            fatalError("data.json not found in the app bundle.")
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
    
    func json() {
        guard let jsonData = test() else { return }
        do {
            let decoder = JSONDecoder()
            let movie = try decoder.decode([CBMovies].self, from: jsonData)
            // Now, you have the JSON data deserialized into the 'movie' instance of your model class.
            print("Movie Title: \(movie.first?.actors)")
            print("Year: \(movie.first?.year)")
            print("Rated: \(movie.first?.director)")
            // Access other properties as needed.
        } catch {
            fatalError("Error decoding JSON data: \(error)")
        }

    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesTableViewCell.self), for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
}
