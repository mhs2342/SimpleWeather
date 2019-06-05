# Dependency Injection with Storyboards

## Requirements
* Xcode 11

Before Xcode 11 there was no way inject dependencies into storyboarded view controllers using a custom initializer. Xcode 11 introduced `@IBSegueAction` which allows you to intercept a segue and use your own default initializer. Attaching the `@IBSegueAction` attribute to any function allows that function to be dynamically called at run-time when the owning view controller is about to segue to another view controller.

## Example

### HomeViewController
```swift

class HomeViewController: UIViewController {
    
    let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBSegueAction func showWeatherViewController(_ coder: NSCoder) -> WeatherViewController? {
        let service = WeatherService()
        return WeatherViewController(coder, locationManager: self.locationManager, service: service)!
    }
}
```
### WeatherViewController
```swift
class WeatherViewController: UIViewController {
    
    var locationManager: LocationManager
    var service: WeatherService
    
    init?(_ coder: NSCoder, locationManager: LocationManager, service: WeatherService) {
        self.locationManager = locationManager
        self.service = service
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

All that is required is that you control+drag your `@IBsegueAction` from your view controller file to your Storyboard's segue. Once you do that, you can set a breakpoint within the 

You can see the full example of this demo by cloning the repo and running it in the simulator.
