//
//  MovieDescriptionViewController.swift
//  ShopBack
//
//  Created by Kamala Tennakoon on 26/7/17.
//  Copyright © 2017 Kamala Tennakoon. All rights reserved.
//

import UIKit
import ReactiveSwift
import Alamofire

class MovieViewController: UIViewController {
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    var movieVM: MovieViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.movieVM.movie?.title
        self.movieVM.fetchMovie {
            if let tmpValue = self.movieVM.overview {
                self.labelDescription.text = tmpValue
            }
            if let tmpValue = self.movieVM.title {
                self.labelTitle.text = tmpValue
            }
            if let tmpValue = self.movieVM.genres {
                self.labelGenres.text = tmpValue
            }
            if let tmpValue = self.movieVM.duration {
                self.labelDuration.text = tmpValue
            }
            if let tmpValue = self.movieVM.poster {
                if let posterUrl = URL(string: "\(BaseUrl.Image)\(tmpValue)") {
                    Alamofire.request(posterUrl)
                        .response { response in
                            guard let imageData = response.data else {
                                print("Could not get image from image URL returned in search results")
                                return
                            }
                            self.imagePoster.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickBooking(_ sender: Any) {
        let vcBooking: BookingViewController = self.storyboard?.instantiateViewController(withIdentifier: "idVCBooking") as! BookingViewController
        vcBooking.movieVM = self.movieVM
        self.navigationController?.pushViewController(vcBooking, animated: false)
    }
}
