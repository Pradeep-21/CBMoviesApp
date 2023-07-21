//
//  ViewController.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 21/07/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var moviesTypesTableView: UITableView!
    let viewModel = CBMoviesViewModel(model: CBMoviesModel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibCell()
        viewModel.getMoviesDetails()
    }
    
    private func registerNibCell() {
        moviesTypesTableView.register(UINib(nibName: String(describing: MoviesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoviesTableViewCell.self))
        moviesTypesTableView.register(UINib(nibName: String(describing: MoviesCategoryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoviesCategoryTableViewCell.self))
        moviesTypesTableView.delegate = self
        moviesTypesTableView.dataSource = self
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
        return viewModel.array?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.array?[section]
        if section?.isOpened == true {
            return (section?.subCategory?.count ?? 0) + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesCategoryTableViewCell.self), for: indexPath) as? MoviesCategoryTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            cell.customise(categoryText: viewModel.array?[indexPath.section].category)
        } else {
            cell.customise(categoryText: viewModel.array?[indexPath.section].subCategory?[indexPath.row - 1])
        }
        return cell
    }
    
}
