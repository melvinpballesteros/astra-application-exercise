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
        
        setupTargets()
        setupContext()
        setupTableView()
        fetchMovies()
    }
    
    // MARK: - Setup    
    private func setupTableView() {
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.delegate = self 
        tableView.dataSource = self 
    }
    
    private func setupContext() {
        headerLabel.text = viewModel.headerTitle
        
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                           NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: viewModel.searchTitle,
                                                         attributes: attributes as [NSAttributedString.Key : Any])
    }
    
    private func setupTargets() {
        searchTextField.addTarget(self, action: #selector(searchMovie), for: .editingChanged)
    }

    
    // MARK: - Events
    
    
    // MARK: - Logic
    private func fetchMovies() {
        /// Start Activity Indicator
        activityIndicatorStart()
        
        viewModel.fetchMovies { 
            DispatchQueue.main.async {
                self.refreshTableView()
                self.activityIndicatorEnd()
            }
            
        } failed: { 
            DispatchQueue.main.async {
                self.viewModel.fetchLocalData()
                self.refreshTableView()
                self.activityIndicatorEnd()
            }
        }
    }
    
    private func refreshTableView() {
        tableView.reloadData()
    }
    
    @objc private func searchMovie() {
        viewModel.searchMovies(searchTextField.text ?? "")
    }

}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelectedMovie(viewModel.movies[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell
        viewModel.movie = viewModel.movies[indexPath.row]
        cell.configure(viewModel)
        return cell
    }
}
