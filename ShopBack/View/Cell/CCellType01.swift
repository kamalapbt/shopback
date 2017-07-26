//
//  Cell01ViewController1.swift
//  ShopBack
//
//  Created by Kamala Tennakoon on 26/7/17.
//  Copyright © 2017 Kamala Tennakoon. All rights reserved.
//

import UIKit
import Alamofire
class CCellType01: UICollectionViewCell {
    @IBOutlet var textPrimary: UILabel!
    @IBOutlet var textSecondary: UILabel!
    @IBOutlet var imageMain: UIImageView!
    var viewModel: CellMoviesViewModel! {
        didSet {
            textPrimary.text = viewModel.primaryText
            textSecondary.text = viewModel.secondaryText
            if let imgUrl: URL = viewModel.posterUrl {
                Alamofire.request(imgUrl)
                    .response { response in
                        guard let imageData = response.data else {
                            return
                        }
                        self.imageMain.image = UIImage(data: imageData)
                }
            }
        }
    }
}
