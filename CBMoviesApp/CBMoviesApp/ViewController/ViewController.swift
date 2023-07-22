//
//  ViewController.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak private var moviesTypesTableView: UITableView!
    
    let viewModel = CBMoviesViewModel(model: CBMoviesModel())
    var searchDispatchWorkItem: DispatchWorkItem?
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibCell()
        viewModel.getMoviesDetails()
        customiseUI()
    }
    
    // MARK: - Custom methods
    
    private func customiseUI() {
        searchTextField.leftView = configureSearchIcon()
        searchTextField.leftViewMode = .always
        searchTextField.layer.cornerRadius = 10
        searchTextField.tintColor = .lightText
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    private func registerNibCell() {
        moviesTypesTableView.register(UINib(nibName: String(describing: MoviesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoviesTableViewCell.self))
        moviesTypesTableView.register(UINib(nibName: String(describing: MoviesCategoryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoviesCategoryTableViewCell.self))
        moviesTypesTableView.delegate = self
        moviesTypesTableView.dataSource = self
    }

    
    @objc private func searchTextChanged() {
        guard let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            viewModel.isSearch = false
            moviesTypesTableView.reloadData()
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
    
    private func moveToMoviesListViewController(subCategory: String?, text: String?) {
        guard let viewController = AppStoryboards.Main.instance.instantiateViewController(withIdentifier: String(describing: CBMoviesListViewController.self)) as? CBMoviesListViewController else { return }
        viewController.subCategoryMovie = subCategory
        viewController.text = text
        viewController.allMovies = viewModel.moviesArray
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isSearch {
            moveToMovieDetailsViewController(movie: viewModel.searchedMovies?[indexPath.row], posterImage: UIImage())
        } else if indexPath.row == 0 {
            
                tableView.deselectRow(at: indexPath, animated: true)
                viewModel.array?[indexPath.section].isOpened?.toggle()
                moviesTypesTableView.reloadSections([indexPath.section], with: .none)
        } else {
            let text = viewModel.array?[indexPath.section].subCategory?[indexPath.row]
            let category = viewModel.array?[indexPath.section].category
            moveToMoviesListViewController(subCategory: category, text: text)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.isSearch {
            return 1
        } else {
            return viewModel.array?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isSearch {
            return viewModel.searchedMovies?.count ?? 0
        } else {
            let section = viewModel.array?[section]
            if section?.isOpened == true {
                if section?.category == CBMovieCategory.allMovies.rawValue {
                    return viewModel.moviesArray?.count ?? 0
                } else {
                    return (section?.subCategory?.count ?? 0)
                }
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((indexPath.row == 0 || indexPath.section != CBMovieCategory.allCases.count - 1) && !viewModel.isSearch) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesCategoryTableViewCell.self), for: indexPath) as? MoviesCategoryTableViewCell else {
                return UITableViewCell()
            }
            if indexPath.row == 0 {
                cell.customise(categoryText: viewModel.array?[indexPath.section].category)
            } else {
                cell.customise(categoryText: viewModel.array?[indexPath.section].subCategory?[indexPath.row])
            }
            if viewModel.array?[indexPath.section].isOpened ?? false {
                cell.expandButton.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
            } else {
                cell.expandButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesTableViewCell.self), for: indexPath) as? MoviesTableViewCell else {
                return UITableViewCell()
            }
            guard let movie = (CBMovieCategory.allCases.count - 1) == indexPath.section ? viewModel.moviesArray?[indexPath.row]: viewModel.searchedMovies?[indexPath.row] else {
                return UITableViewCell()
            }
            cell.customUI(movie: movie)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isSearch || indexPath.section == CBMovieCategory.allCases.count - 1 && indexPath.row != 0 {
            return 75
        } else {
            return 44
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return CBMovieCategory.allCases[section].rawValue
//    }
    
}

func configureSearchIcon() -> UIView? {
    let imageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 30, height: 20))
    imageView.image = UIImage(systemName: "magnifyingglass")
    let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0,width: 50, height: 40))
    imageContainerView.addSubview(imageView)
    return imageContainerView
}

