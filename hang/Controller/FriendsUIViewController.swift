//
//  FriendsUIViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Mapbox

class FriendsUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MGLMapViewDelegate {
    
  
    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var tableView: UITableView!
    var friends : Array<Dictionary<String,String>> = placeholderFriends
    
    @IBOutlet weak var statusPicker: UIPickerView!
    var availabilityPicker: AvailabilityPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        
        statusPicker.delegate = availabilityPicker
        statusPicker.dataSource = availabilityPicker
        
        mapView.showsUserLocation = true
        mapView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        let location = mapView.userLocation?.location
        mapView.setCenter(CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!),zoomLevel: 15, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsTableViewCell
        let friend = friends[indexPath.row]
        
        cell.name.text = friend["name"]
        cell.info.text = friend["distance"]
        cell.emoji.text = friend["emoji"]

        return cell
    }

}
