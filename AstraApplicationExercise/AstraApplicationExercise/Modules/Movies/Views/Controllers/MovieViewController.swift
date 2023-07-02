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
        /// Fetch Movies - API
        fetchMovies()
        /// Setup Realm Observer
        viewModel.setupRealmObserver(tableView: tableView)
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
    @objc private func userTapDetailPage() {
        let controller = MovieDetailViewController()
        controller.movieViewModel = viewModel
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
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
        tableView.reloadData()
    }

}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.index = indexPath.row
        userTapDetailPage()
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
        /// Set the model and selected index
        // viewModel.movie = viewModel.movies[indexPath.row]
        viewModel.index = indexPath.row
        
        /// Check if item is favorite
        viewModel.checkFavoriteMovie(index: indexPath.row)
        /// Configure the cell with view model
        cell.configure(viewModel: viewModel)
        /// Like / UnLike Favorites
        cell.tapFavorite = {
            self.viewModel.likeUnlikeMovie(index: indexPath.row)
        }
        return cell
    }
}
