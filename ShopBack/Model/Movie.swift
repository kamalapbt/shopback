//
//  Movie.swift
//  ShopBack
//
//  Created by Kamala Tennakoon on 26/7/17.
//  Copyright © 2017 Kamala Tennakoon. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftyJSON

struct Movie {
    let vote_count: Int
    let id: Int
    let video: Bool
    let vote_average: Int
    let title: String
    let popularity: Float
    let poster_path: String
    let original_language: String
    let original_title: String
    let genre_ids: [Int]
    let backdrop_path: String
    let adult: Bool
    let overview: String
    let release_date: String
}

