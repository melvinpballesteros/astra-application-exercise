//
//  MovieViewController.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import UIKit

class MovieViewController: BaselineViewController {
    
    // MARK: - Variables
    let viewModel = MovieViewModel()

    // MARK: - View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContext()
        setupTableView()
    }
    
    // MARK: - Setup    
    private func setupTableView() {
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.delegate = self 
        tableView.dataSource = self 
    }
    
    private func setupContext() {
        headerLabel.text = viewModel.headerTitle
    }
    
    
    
    // MARK: - Events
    
    
    // MARK: - Logic
    private func fetchMovies() {
        
    }

}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell
        viewModel.movie = viewModel.movies[indexPath.row]
        cell.configure(viewModel)
        return cell
    }
}
