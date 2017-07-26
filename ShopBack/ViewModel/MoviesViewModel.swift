//
//  MoviesViewModel.swift
//  ShopBack
//
//  Created by Kamala Tennakoon on 25/7/17.
//  Copyright © 2017 Kamala Tennakoon. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftyJSON
import Result
import Alamofire

class MoviesViewModel {
    let title: String = "Latest Movies"
    var movies : [Movie]?
    var totalResults: Int?
    var totalPages: Int?
    var page: Int?
    var sortBy: String?
    
   
    func fetchLatestMovies(onCompletion: @escaping () ->()) {
        var target = "\(BaseUrl.Api)"
        if self.sortBy != nil {
            target.append("&sort_by=\(self.sortBy!)")
        } else {
            target.append("&sort_by=release_date.desc")
        }
        if self.page != nil {
            target.append("&page=\(self.page!)")
        }
        let requestTarget: URL = URL(string: target)!
        Alamofire.request(requestTarget, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (responce) in
            if let json: JSON = JSON(responce.value) {
                self.totalResults = json["total_results"].intValue
                self.totalPages = json["total_pages"].intValue
                if let items: [JSON] = json["results"].array {
                    for i in 0 ..< items.count {
                        let tmpData = items[i]
                        let tmpVoteCount = tmpData["vote_count"].intValue
                        let tmpId = tmpData["id"].intValue
                        let tmpVideo = tmpData["video"].boolValue
                        let tmpVoteAverage = tmpData["vote_average"].intValue
                        let tmpTitle = tmpData["title"].stringValue
                        let tmpPopularity = tmpData["popularity"].floatValue
                        let tmpPosterPath = tmpData["poster_path"].stringValue
                        let tmpOriginalLang = tmpData["original_language"].stringValue
                        let tmpOriginalTitle = tmpData["original_title"].stringValue
                        let tmpGenreIds = tmpData["genre_ids"].arrayValue
                        var tmpGenre: [Int] = [Int]()
                        for val in tmpGenreIds {
                            tmpGenre.append(val.intValue)
                        }
                        let tmpBackdropPath = tmpData["backdrop_path"].stringValue
                        let tmpAdult = tmpData["adult"].boolValue
                        let tmpOverview = tmpData["overview"].stringValue
                        let tmpReleaseDate = tmpData["release_date"].stringValue
                        
                        let formattedData: Movie = Movie(vote_count: tmpVoteCount, id: tmpId, video: tmpVideo, vote_average: tmpVoteAverage, title: tmpTitle, popularity: tmpPopularity, poster_path: tmpPosterPath, original_language: tmpOriginalLang, original_title: tmpOriginalTitle, genre_ids: tmpGenre, backdrop_path: tmpBackdropPath, adult: tmpAdult, overview: tmpOverview, release_date: tmpReleaseDate)
                        if (self.movies != nil) {
                            self.movies!.append(formattedData)
                        } else {
                            self.movies = [formattedData]
                        }
                    }
                }
            }
            onCompletion()
        })
    }
    func getMoviesCount() -> Int {
        if let prjCounts: Int = movies?.count {
            return prjCounts
        }
        return 0
    }
    func getMovieForIndex(index: Int) -> Movie {
        return movies![index]
    }
    func createMovieCell(index: Int)-> CellMoviesViewModel {
        let tmpMovie: Movie = movies![index]
        return CellMoviesViewModel.init(withMovie: tmpMovie)
    }
}
struct CellMoviesViewModel {
    let primaryText: String
    let secondaryText: String
    var posterUrl: URL? = nil
    init(withMovie movie: Movie) {
        self.primaryText = movie.title
        self.secondaryText = "\(movie.popularity)"
        if (movie.poster_path != nil) && (movie.poster_path != "") {
            self.posterUrl = URL(string: "\(BaseUrl.Image)\(movie.poster_path)")
        } else {
            if (movie.backdrop_path != nil ) && (movie.backdrop_path != ""){
                self.posterUrl = URL(string: "\(BaseUrl.Image)\(movie.backdrop_path)")
            }
        }
    }
}
