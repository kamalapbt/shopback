//
//  BookingViewController.swift
//  ShopBack
//
//  Created by Kamala Tennakoon on 26/7/17.
//  Copyright © 2017 Kamala Tennakoon. All rights reserved.
//

import UIKit
import ReactiveSwift
import Alamofire



class BookingViewController: UIViewController {
    @IBOutlet weak var webviewBooking: UIWebView!
    var movieVM: MovieViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Booking"
        if let catheyUrl: URL = URL(string: "http://www.cathaycineplexes.com.sg/") {
            self.webviewBooking.loadRequest(URLRequest.init(url: catheyUrl))
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
