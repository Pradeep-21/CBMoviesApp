//
//  CBViewController.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import UIKit

let kTableViewMovieHeightConstant = 75.0
private let kTableTitleHeightConstant = 45.0

class CBViewController: UIViewController {
    @IBOutlet weak private var emptyDataLabel: UILabel!
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var moviesTypesTableView: UITableView!
    
    let viewModel = CBMoviesViewModel(model: CBMoviesModel())
    var searchDispatchWorkItem: DispatchWorkItem?
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBinding()
        registerNibCell()
        viewModel.getMoviesDetails()
        customiseUI()
    }
    
    // MARK: - Custom methods
    
    private func customiseUI() {
        searchTextField.leftView = CBHelper.configureSearchIcon()
        searchTextField.leftViewMode = .always
        searchTextField.layer.cornerRadius = 10
        searchTextField.tintColor = .lightText
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        searchTextField.backgroundColor = .CBSearchTextBackground
        searchTextField.tintColor = .CCSearchTextTint
    }
    
    private func addBinding() {
        viewModel.movieSections.bind { [weak self] movie in
            guard let self else { return }
            self.emptyDataLabel.isHidden = !(movie?.isEmpty ?? true)
            self.reloadTableView()
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.moviesTypesTableView.reloadData()
        }
    }
    
    private func registerNibCell() {
        moviesTypesTableView.register(UINib(nibName: String(describing: CBMoviesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CBMoviesTableViewCell.self))
        moviesTypesTableView.register(UINib(nibName: String(describing: CBMoviesCategoryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CBMoviesCategoryTableViewCell.self))
        moviesTypesTableView.delegate = self
        moviesTypesTableView.dataSource = self
    }

    
    @objc private func searchTextChanged() {
        guard let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            viewModel.resetSelectedSectionBool()
            return
        }
        viewModel.isSearch = true
        
        // Cancel the currently pending item
        searchDispatchWorkItem?.cancel()
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.viewModel.searchMovies(from: searchText)
            self.moviesTypesTableView.reloadData()
        }
        
        // Save the new work item and execute it after 250 ms
        searchDispatchWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem) // We should not hit API at when user continously typing. We adding this delay to make user we are not hitting API too frequetly in this case. We need to hit API after `kMinimumTypingInterval`
    }
    
    private func moveToMovieDetailsViewController(movie: CBMovies?, posterImage: UIImage?) {
        guard let viewController = AppStoryboards.Main.instance.instantiateViewController(withIdentifier: String(describing: CBMovieDetailsViewController.self)) as? CBMovieDetailsViewController else { return }
        viewController.movie = movie
        viewController.movieImage = posterImage
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func moveToMoviesListViewController(category: CBMovieCategory?, subCategory: String?) {
        guard let viewController = AppStoryboards.Main.instance.instantiateViewController(withIdentifier: String(describing: CBMoviesListViewController.self)) as? CBMoviesListViewController else { return }
        viewController.category = category
        viewController.subCategory = subCategory
        viewController.allMovies = viewModel.allMovies
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDelegate Methods

extension CBViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.isSearch {
            moveToMovieDetailsViewController(movie: viewModel.filteredMovies.value?[indexPath.row], posterImage: UIImage())
        } else if indexPath.row == 0 {
            viewModel.movieSections.value?[indexPath.section].isOpened?.toggle()
            moviesTypesTableView.reloadSections([indexPath.section], with: .none)
        } else if indexPath.section == CBMovieCategory.allCases.count - 1 {
            moveToMovieDetailsViewController(movie: viewModel.allMovies?[indexPath.row], posterImage: UIImage())
        } else {
            let subCategory = viewModel.movieSections.value?[indexPath.section].subCategory?[indexPath.row]
            let category = viewModel.movieSections.value?[indexPath.section].category
            moveToMoviesListViewController(category: category, subCategory: subCategory)
        }
    }
}

// MARK: - UITableViewDataSource Methods

extension CBViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.isSearch {
            return 1
        } else {
            return viewModel.movieSections.value?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isSearch {
            return viewModel.filteredMovies.value?.count ?? 0
        } else {
            let section = viewModel.movieSections.value?[section]
            if section?.isOpened == true {
                if section?.category == CBMovieCategory.allMovies {
                    return viewModel.allMovies?.count ?? 0
                } else {
                    return section?.subCategory?.count ?? 0
                }
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((indexPath.row == 0 || indexPath.section != CBMovieCategory.allCases.count - 1) && !viewModel.isSearch) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CBMoviesCategoryTableViewCell.self), for: indexPath) as? CBMoviesCategoryTableViewCell else {
                return UITableViewCell()
            }
            cell.customise(movieSection: viewModel.movieSections.value?[indexPath.section], index: indexPath.row, isSection: indexPath.row == 0)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CBMoviesTableViewCell.self), for: indexPath) as? CBMoviesTableViewCell else {
                return UITableViewCell()
            }
            guard let movie = indexPath.section == (CBMovieCategory.allCases.count - 1) ? viewModel.allMovies?[indexPath.row]: viewModel.filteredMovies.value?[indexPath.row] else {
                return UITableViewCell()
            }
            cell.customUI(movie: movie)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isSearch || indexPath.section == CBMovieCategory.allCases.count - 1 && indexPath.row != 0 {
            return kTableViewMovieHeightConstant
        } else {
            return kTableTitleHeightConstant
        }
    }
}

