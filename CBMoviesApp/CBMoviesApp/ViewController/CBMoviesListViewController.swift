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
    
    var category: CBMovieCategory?
    var subCategory: String?
    var allMovies: [CBMovies]?
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category?.rawValue.capitalized
        registerNibCell()
        viewModel.fetchSubMovieList(from: allMovies, with: category, and: subCategory)
        moviesListTableView.reloadData()
    }
    
    // MARK: - Custom methods
    
    private func registerNibCell() {
        moviesListTableView.register(UINib(nibName: String(describing: CBMoviesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CBMoviesTableViewCell.self))
        moviesListTableView.delegate = self
        moviesListTableView.dataSource = self
    }
    
    private func addBinding() {
        viewModel.filteredMovies.bind { [weak self] _ in
            guard let self else { return }
            self.reloadTableView()
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.moviesListTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource Methods

extension CBMoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredMovies.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CBMoviesTableViewCell.self), for: indexPath) as? CBMoviesTableViewCell else {
            return UITableViewCell()
        }
        guard let movie = viewModel.filteredMovies.value?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.customUI(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTableViewMovieHeightConstant
    }
    
}

// MARK: - UITableViewDelegate Methods

extension CBMoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = AppStoryboards.Main.instance.instantiateViewController(withIdentifier: String(describing: CBMovieDetailsViewController.self)) as? CBMovieDetailsViewController else { return }
        viewController.movie = viewModel.filteredMovies.value?[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}
