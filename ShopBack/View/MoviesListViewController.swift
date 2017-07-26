//
//  File.swift
//  ShopBack
//
//  Created by Kamala Tennakoon on 26/7/17.
//  Copyright © 2017 Kamala Tennakoon. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

class MoviesListViewController: UIViewController {
    @IBOutlet weak var collectionMovies: UICollectionView!
    fileprivate var moviesVM: MoviesViewModel!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MoviesListViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionMovies.dataSource = self
        self.collectionMovies.delegate = self
        self.moviesVM = MoviesViewModel.init()
        self.moviesVM.fetchLatestMovies {
            DispatchQueue.main.async {
                self.collectionMovies.reloadData()
            }
        }
        self.collectionMovies.addSubview(self.refreshControl)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = moviesVM.title
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        self.moviesVM.movies = nil
        self.moviesVM.page = nil
        self.moviesVM.fetchLatestMovies {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.collectionMovies.reloadData()
            }
        }
    }
}
extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesVM.getMoviesCount()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! CCellType01
        cell.viewModel = self.moviesVM.createMovieCell(index: indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (self.moviesVM.getMoviesCount() - 1) {
            var currentPage = 1
            if let tmpPage = self.moviesVM.page {
                currentPage = tmpPage
            }
            if (self.moviesVM.totalPages != nil) && (currentPage < self.moviesVM.totalPages!) {
                self.moviesVM.page = currentPage + 1
                self.moviesVM.fetchLatestMovies {
                    DispatchQueue.main.async {
                        self.collectionMovies.reloadData()
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vcMovie: MovieViewController = self.storyboard?.instantiateViewController(withIdentifier: "idVCMovie") as! MovieViewController
        vcMovie.movieVM = MovieViewModel.init(movie: self.moviesVM.getMovieForIndex(index: indexPath.item))
        self.navigationController?.pushViewController(vcMovie, animated: true)
    }
    
}

