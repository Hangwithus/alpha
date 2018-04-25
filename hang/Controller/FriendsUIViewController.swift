//
//  FriendsUIViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit

class FriendsUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    @IBOutlet weak var tableView: UITableView!
    var friends : Array<Dictionary<String,String>> = placeholderFriends
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //tableview
        tableView.backgroundColor = UIColor.clear
//        tableView.layer.cornerRadius = 10
//        tableView.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
//        cell.layer.cornerRadius=10 //set corner radius here
//        cell.layer.borderWidth = 2 // set border width here

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
            //Top Left Right Corners
            let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
            let shapeLayerTop = CAShapeLayer()
            shapeLayerTop.frame = cell.bounds
            shapeLayerTop.path = maskPathTop.cgPath
            
            //Bottom Left Right Corners
            let maskPathBottom = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
            let shapeLayerBottom = CAShapeLayer()
            shapeLayerBottom.frame = cell.bounds
            shapeLayerBottom.path = maskPathBottom.cgPath
            
            //All Corners
            let maskPathAll = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: 8.0, height: 8.0))
            let shapeLayerAll = CAShapeLayer()
            shapeLayerAll.frame = cell.bounds
            shapeLayerAll.path = maskPathAll.cgPath
            
            if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1)
            {
                cell.layer.mask = shapeLayerAll
            }
            else if (indexPath.row == 0)
            {
                cell.layer.mask = shapeLayerTop
            }
            else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1)
            {
                cell.layer.mask = shapeLayerBottom
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
