//
//  AddController.swift
//  hang
//
//  Created by Joe Kennedy on 4/18/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import Mapbox

class MapController: UIViewController, MGLMapViewDelegate {
    
    var user:Users?
    let mapView = MGLMapView()
    let chatArea = UIView()
    let chatField = UITextField()
    let chatSend = UIButton(type: .system)
    let boldLabel = UIFont(name: "Nunito-Bold", size: UIFont.labelFontSize)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MapController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.title = user?.name
        self.navigationController?.navigationBar.titleTextAttributes = [ kCTFontAttributeName: UIFont(name: "Nunito-Bold", size: 17)!] as [NSAttributedStringKey : Any]

        mapView.delegate = self
        //mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742), zoomLevel: 9, animated: false)
        self.view.addSubview(mapView)
        self.view.addSubview(chatArea)
        self.chatArea.addSubview(chatField)
        self.chatArea.addSubview(chatSend)

        mapView.showsUserLocation = true
        mapView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(-120)
        }
        chatArea.backgroundColor = .white
        chatArea.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(120)
        }
        chatField.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.92, alpha:1.00)
        //chatField.frame = CGRect(x: 12, y: 5, width: 100, height: 35)
        chatField.layer.cornerRadius = 8
        chatField.layer.masksToBounds = true
        chatField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        chatField.placeholder = "Say something..."
        
        chatField.snp.makeConstraints { (make) in
            make.left.equalTo(chatArea).offset(16)
            make.right.equalTo(chatArea).inset(70)
            make.height.equalTo(44)
            make.centerY.equalTo(chatArea)
            
        }
        
//        button.backgroundColor = UIColor(red:0.10, green:0.87, blue:0.19, alpha:1.00)
        chatSend.setTitle("Send", for: .normal)
        chatSend.setTitleColor(UIColor(red:0.10, green:0.87, blue:0.19, alpha:1.00), for: .normal)
        if #available(iOS 11.0, *) {
            chatSend.titleLabel?.font = UIFontMetrics.default.scaledFont(for: boldLabel!)
        } else {
            // Fallback on earlier versions
        }
        chatSend.titleLabel?.adjustsFontForContentSizeCategory = true
//        chatSend.layer.cornerRadius = 26
//        chatSend.layer.masksToBounds = true
//        chatSend.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        chatSend.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        
        chatSend.snp.makeConstraints { (make) in
            make.right.equalTo(chatArea).inset(16)
            make.centerY.equalTo(chatArea)

        }
        //        // Do any additional setup after loading the view.

    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        let location = mapView.userLocation?.location
        mapView.setCenter(CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!),zoomLevel: 15, animated: false)

    }

    
    @objc func handleFriends() {
        
        self.dismiss(animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func sendAction() {
        self.view.endEditing(true)
        
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
