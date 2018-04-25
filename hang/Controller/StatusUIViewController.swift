//
//  StatusUIViewController.swift
//  hang
//
//  Created by Andrew Sibert on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit

class AvailabilityPicker: UIPickerView {
    let customWidth:CGFloat = 100
    let customHeight:CGFloat = 100
}

extension AvailabilityPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //Limit columns in picker view to 1
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //Return how many rows needed from data
        return status.count
    }
}

extension AvailabilityPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //Define the superview
        let view = UIView(frame: CGRect(x: 0, y: 0, width: customWidth, height: customHeight))
        
        //Define labels
        let statusEmoji = UILabel(frame: CGRect(x: 0, y: 0, width: customWidth, height: customHeight))
        
        //Define labels datasources
        statusEmoji.text = status[row]
        
        //Add subviews
        view.addSubview(statusEmoji)
        
        return view
    }
}
