//
//  Place.swift
//  iOSApp
//
//  Created by Colton Wiethorn on 4/26/19.
//  Copyright © 2019 Colton Wiethorn. All rights reserved.
//

import UIKit
import Foundation

public class Place {
    public var name: String
    public var placeid: Int
    public var category: Array<String>
    
    public init(name: String, id: Int){
        self.name = name
        self.placeid = id
        category = [String]()
    }
    
    public init (jsonStr: String){
        self.name = ""
        self.placeid=0
        self.category = [String]()
        if let data: NSData = jsonStr.data(using: String.Encoding.utf8) as NSData?{
            do{
                let dict = try JSONSerialization.jsonObject(with: data as Data,options:.mutableContainers) as?[String:AnyObject]
                self.name = (dict!["name"] as? String)!
                self.placeid = (dict!["placeid"] as? Int)!
                self.category = (dict!["category"] as? Array<String>)!
            } catch {
                print("unable to convert Json to a dictionary")
                
            }
        }
    }
    
    public init(dict:[String:Any]){
        self.name = dict["name"] == nil ? "unknown" : dict["name"] as! String
        self.placeid = dict["placeid"] == nil ? 0 : dict["placeid"] as! Int
        self.category = [String]()
        let categoryArr:[String] = dict["category"] == nil ? [String]() : dict["category"] as! [String]
        for aCrs:String in categoryArr {
            self.category.append(aCrs)
        }
    }
    
    public func toJsonString() -> String {
        var jsonStr = "";
        let dict:[String : Any] = ["name": name, "placeid": placeid, "category":category] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        } catch let error as NSError {
            print("unable to convert dictionary to a Json Object with error: \(error)")
        }
        return jsonStr
    }
}
