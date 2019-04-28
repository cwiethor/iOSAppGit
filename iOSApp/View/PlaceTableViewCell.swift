//
//  DataViewController.swift
//  iOSApp
//
//  Created by Colton Wiethorn on 4/26/19.
//  Copyright © 2019 Colton Wiethorn. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var placeNumLab: UILabel!
    @IBOutlet weak var placeTitleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var placeNum:String? {
        set {
            placeNumLab.text = newValue
        }
        get {
            return placeNumLab.text
        }
    }
    
    var placeTitle:String? {
        set {
            placeTitleLab.text = newValue
        }
        get {
            return placeTitleLab.text
        }
    }
}

