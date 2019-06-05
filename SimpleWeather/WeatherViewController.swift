//
//  WeatherViewController.swift
//  SimpleWeather
//
//  Created by Matt Sanford on 6/5/19.
//  Copyright © 2019 Matt Sanford. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: Dependencies
    var locationManager: LocationManager
    var service: WeatherService
    
    // MARK: Views
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    init?(_ coder: NSCoder, locationManager: LocationManager, service: WeatherService) {
        self.locationManager = locationManager
        self.service = service
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // Do any additional setup after loading the view.
        
        locationManager.getInfo { [weak self] (city, zip) in
            guard let self = self else { return }
            self.locationLabel.text = city
        }
        
        if let lat = locationManager.mostRecentLocation?.coordinate.latitude,
            let long = locationManager.mostRecentLocation?.coordinate.longitude {
            service.getCurrentWeather(lat: lat, long: long) { (result) in
                switch result {
                case .success(let weather):
                    self.tempLabel.text = "\(weather.main.temp)°"
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
