//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Matt Sanford on 6/5/19.
//  Copyright © 2019 Matt Sanford. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func allowLocationTapped(_ sender: Any) {
        locationManager.requestAuthorization()
    }
    
    @IBSegueAction func showWeatherViewController(_ coder: NSCoder) -> WeatherViewController? {
        let service = WeatherService()
        return WeatherViewController(coder, locationManager: self.locationManager, service: service)!
    }
}

