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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibCell()
        viewModel.getMoviesDetails()
        customiseUI()
    }
    
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
        guard let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            viewModel.isSearch = false
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
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.array?[indexPath.section].isOpened?.toggle()
        moviesTypesTableView.reloadSections([indexPath.section], with: .none)
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
                return (section?.subCategory?.count ?? 0)
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isSearch {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesTableViewCell.self), for: indexPath) as? MoviesTableViewCell else {
                return UITableViewCell()
            }
            guard let movie = viewModel.searchedMovies?[indexPath.row] else {
                return UITableViewCell()
            }
            cell.customUI(movie: movie)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesCategoryTableViewCell.self), for: indexPath) as? MoviesCategoryTableViewCell else {
                return UITableViewCell()
            }
            if indexPath.row == 0 {
                cell.customise(categoryText: viewModel.array?[indexPath.section].category)
            } else {
                cell.customise(categoryText: viewModel.array?[indexPath.section].subCategory?[indexPath.row])
            }
            return cell
        }
    }
    
}

func configureSearchIcon() -> UIView? {
    let imageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 30, height: 20))
    imageView.image = UIImage(systemName: "magnifyingglass")
    let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0,width: 55, height: 40))
    imageContainerView.addSubview(imageView)
    return imageContainerView
}

