//
//  FriendsUIViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Mapbox

class FriendsUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MGLMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
  
    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var tableView: UITableView!
    var friends : Array<Dictionary<String,String>> = placeholderFriends
    
    @IBOutlet weak var statusPicker: UIPickerView!
    
    @IBOutlet weak var statusRing: UIImageView!
    
    //Fonts
    let semiBoldLabel = UIFont(name: "Nunito-SemiBold", size: UIFont.labelFontSize)
    let semiBoldLabelSmall = UIFont(name: "Nunito-SemiBold", size: UIFont.smallSystemFontSize)
    let boldLabel = UIFont(name: "Nunito-Bold", size: UIFont.labelFontSize)
    
    //Picker variables
    var pickerRowVariable = 0
    let pickerView = UIPickerView()
    var rotationAngle: CGFloat!
    let width:CGFloat = 300
    let height:CGFloat = 300
    
    //var availabilityPicker: AvailabilityPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
                
        //statusPicker.delegate = availabilityPicker
        //statusPicker.dataSource = availabilityPicker
        
        statusPicker.delegate  = self
        statusPicker.dataSource = self
        
        //Status picker rotation
        rotationAngle = -90 * (.pi/180)
        statusPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        mapView.showsUserLocation = true
        mapView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //picker code
    
    func numberOfComponents(in statusPicker: UIPickerView) -> Int {
        //Limit columns in picker view to 1
        return 1
    }
    
    func pickerView(_ statusPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //Return how many rows needed from data
        return status.count
    }
    
    func pickerView(_ statusPicker: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return height
    }
    
    func pickerView(_ statusPicker: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return width
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //Check whether user is unavailable or available
        if row == 0 {
            //Show the selector ring image if unavailable
            statusRing.isHighlighted = false
        } else {
            //Show the selector ring image if unavailable
            statusRing.isHighlighted = true
        }
    }
    
    
    //Create Custom UI View
    func pickerView(_ statusPicker: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            view.backgroundColor = UIColor.white
        
        let label = UILabel()

            label.frame = CGRect(x: 0, y: 0, width: width, height: height)
            label.textAlignment = .center
            
        if #available(iOS 11.0, *) {
            label.font = UIFontMetrics.default.scaledFont(for: boldLabel!)
        } else {
            // Fallback on earlier versions
        }
            label.text = status[row]
        
        let label2 = UILabel()
            label2.textColor = UIColor.white
            label2.frame = CGRect(x:0, y:20, width:width, height:height)
            label2.textAlignment = .center
        if #available(iOS 11.0, *) {
            label2.font = UIFontMetrics.default.scaledFont(for: semiBoldLabel!)
        } else {
            // Fallback on earlier versions
        }
            label2.text = statusText[row]
        
        view.addSubview(label2)
        view.addSubview(label)
        
        //View rotation
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
    
    return view
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Everything else
    
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
