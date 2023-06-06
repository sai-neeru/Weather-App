//
//  ViewController.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/5/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import UIKit
import CoreLocation

/* most for the focus is on structuring code created network layer using protocal oriented,
 created preference handle for storing data,
 created services for api calls so can be mocked with view models while handling unit tests
 created image chache with customview,
 havent focused much on UI and swift UI due to time constraint.
 notification to get location information from location manager if need more screens can observe the change
 for simplicity used storyboards can also create programatical UI as well*/
class HomeController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var name: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var weatherIcon: CustomImageView!
    
    
    private let notificationCenter = NotificationCenter.default
    var homeViewModel = HomeViewModel()
    
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let lat = PreferenceHandler.getValuesForKey("lattitude"), let lon = PreferenceHandler.getValuesForKey("longittude") else {
            LocationManager.shared.requestLocationAuthorization()
            observerNotification()
            self.searchBar.endEditing(true)
            return
        }
        getWeather(lat: lat as! Double, lon: lon as! Double)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear (_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeather(lat: Double, lon: Double) {
        self.homeViewModel.getWeather(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success:
                self?.tableView.isHidden = true
                self?.updateUI()
            case .failure:
                break
            }
        }
    }
    
    func updateUI() {
        if let name = PreferenceHandler.getValuesForKey("name") {
            self.name.text = name as? String
        } else {
            name.text = homeViewModel.name
        }
        temperature.text = homeViewModel.temperature
        weather.text = homeViewModel.weatherDescription
        weatherIcon.urlString = homeViewModel.weatherImage
    }
    
    func observerNotification() {
        notificationCenter.addObserver(forName: .sharedLocation, object: nil, queue: .main) { [weak self] notification in
            guard let location = notification.object as? CLLocation else { return }
            self?.getWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
    }
}

extension HomeController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        homeViewModel.getCoordinates(searchStr: searchBar.text ?? "", completionHandler: { [weak self] result in
            switch result {
            case .success:
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            case .failure:
                self?.tableView.isHidden = true
                //Show error message
            }
            
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.resignFirstResponder()
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeViewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = "\(homeViewModel.searchResults[indexPath.row].name), \(homeViewModel.searchResults[indexPath.row].state)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeViewModel.searchLocation = homeViewModel.searchResults[indexPath.row]
        self.getWeather(lat: homeViewModel.searchResults[indexPath.row].lat, lon: homeViewModel.searchResults[indexPath.row].lon)
    }
}




