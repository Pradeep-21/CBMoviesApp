//
//  CBMoviesListViewController.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import UIKit

class CBMoviesListViewController: UIViewController {

    @IBOutlet weak private var moviesListTableView: UITableView!
    
    private let viewModel = CBMoviesListViewModel()
    
    var subCategoryMovie: String?
    var text: String?
    var allMovies: [CBMovies]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = subCategoryMovie?.capitalized
        registerNibCell()
        viewModel.fetchSubMovieList(from: allMovies, with: subCategoryMovie, text: text)
        moviesListTableView.reloadData()
    }
    

    private func registerNibCell() {
        moviesListTableView.register(UINib(nibName: String(describing: MoviesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoviesTableViewCell.self))
        moviesListTableView.delegate = self
        moviesListTableView.dataSource = self
    }
}

extension CBMoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchedMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesTableViewCell.self), for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell()
        }
        guard let movie = viewModel.searchedMovies?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.customUI(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

extension CBMoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = AppStoryboards.Main.instance.instantiateViewController(withIdentifier: String(describing: CBMovieDetailsViewController.self)) as? CBMovieDetailsViewController else { return }
        viewController.movie = viewModel.searchedMovies?[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}
