//
//  MoviesViewModel.swift
//  ShopBack
//
//  Created by Kamala Tennakoon on 25/7/17.
//  Copyright © 2017 Kamala Tennakoon. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift
import SwiftyJSON
import Result

class MovieViewModel {
    var movie : Movie?
    var title: String?
    var genres: String?
    var duration: String?
    var overview: String?
    var poster: String?
    init(movie: Movie?) {
        self.movie = movie
    }
    func fetchMovie(onCompletion: @escaping () ->()) {
        if let movieId = self.movie?.id {
            var target = "\(BaseUrl.Movie)\(movieId)?api_key=328c283cd27bd1877d9080ccb1604c91"
            let requestTarget: URL = URL(string: target)!
            Alamofire.request(requestTarget, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (responce) in
                if let json: JSON = JSON(responce.value) {
                    self.title = json["title"].stringValue
                    for tmpGenre in json["genres"].arrayValue {
                        if self.genres == nil {
                            self.genres = tmpGenre["name"].stringValue
                        } else {
                            self.genres!.append(", \(tmpGenre["name"].stringValue)")
                        }
                    }
                    self.duration = "\(json["runtime"].stringValue)"
                    self.overview = json["overview"].stringValue
                    self.poster = json["poster_path"].stringValue
                    if ((self.poster == nil) || (self.poster! == "")) {
                        self.poster = json["backdrop_path"].stringValue
                    }
                }
                onCompletion()
            })
        }
    }
}





