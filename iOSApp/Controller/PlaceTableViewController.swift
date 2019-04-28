//
//  RootViewController.swift
//  iOSApp
//
//  Created by Colton Wiethorn on 4/26/19.
//  Copyright © 2019 Colton Wiethorn. All rights reserved.
//

import UIKit

class PlaceTableViewController: UITableViewController {

    var places:[String:Place] = [String:Place]()
    var names:[String] = [String]()
    
    @IBOutlet weak var placeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("viewDidLoad")
        
        // add an edit button, which is handled by the table view editing forRowAt
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // place an add button on the right side of the nav bar for adding a student
        // call addStudent function when clicked.
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(PlaceTableViewController.addDestination))
        self.navigationItem.rightBarButtonItem = addButton
        
        let home:Place = Place(jsonStr: "{\"name\":\"Home\",\"placeid\":60124,\"category\":[\"Food My house is a great place to eat\",\"Sleep Great place to rest\"]}")
        self.places["Home"] = home
        
        if let path = Bundle.main.path(forResource: "places", ofType: "json"){
            do {
                let jsonStr:String = try String(contentsOfFile:path)
                let data:Data = jsonStr.data(using: String.Encoding.utf8)!
                let dict:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                for aStudName:String in dict.keys {
                    let aStud:Place = Place(dict: dict[aStudName] as! [String:Any])
                    self.places[aStudName] = aStud
                }
            } catch {
                print("contents of places.json could not be loaded")
            }
        }
        // sort so the names are listed in the table alphabetically (first name)
        self.names = Array(places.keys).sorted()
        self.title = "Destination List"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // called with the Navigation Bar Add button (+) is clicked
    @objc func addDestination() {
        print("add Destination button clicked")
        
        //  query the user for the new student name and number. empty category
        let promptND = UIAlertController(title: "New Destination", message: "Enter Destination & Zip Code", preferredStyle: UIAlertController.Style.alert)
        // if the user cancels, we don't want to add a student so nil handler
        promptND.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        // setup the OK action and provide a closure to be executed when/if OK selected
        promptND.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //print("you entered name: \(String(describing: promptND.textFields?[0].text)). Number: \(String(describing: promptND.textFields?[1].text)).")
            // Want to provide default values for name and placeid
            let newStudName:String = (promptND.textFields?[0].text == "") ?
                "unknown" : (promptND.textFields?[0].text)!
            // since didn't specify the keyboard, don't know whether id is empty, alpha, or numeric:
            var newStudID:Int = -1
            if let myNumber = NumberFormatter().number(from: (promptND.textFields?[1].text)!) {
                newStudID = myNumber.intValue
            }
            //print("creating and adding student \(newStudName) with id: \(newStudID)")
            let aStud:Place = Place(name: newStudName, id: newStudID)
            self.places[newStudName] = aStud
            self.names = Array(self.places.keys).sorted()
            self.tableView.reloadData()
        }))
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Destination"
        })
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Zip Code"
        })
        present(promptND, animated: true, completion: nil)
    }
    
    // Support editing of the table view. Note, edit button must have been added
    // to the navigationitem (in this case left side) explicitly (view did load)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("tableView editing row at: \(indexPath.row)")
        if editingStyle == .delete {
            let selectedPlace:String = names[indexPath.row]
            print("deleting the Destination \(selectedPlace)")
            places.removeValue(forKey: selectedPlace)
            names = Array(places.keys)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // don't need to reload data, using delete to make update
        }
    }
    
    // MARK: - Table view data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get and configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let aStud = places[names[indexPath.row]]! as Place
        cell.textLabel?.text = aStud.name
        cell.detailTextLabel?.text = "\(aStud.placeid)"
        return cell
    }
    
    // MARK: - Navigation
    // Storyboard seque: do any advance work before navigation, and/or pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object (and model) to the new view controller.
        //NSLog("seque identifier is \(String(describing: segue.identifier))")
        if segue.identifier == "PlaceDetail" {
            let viewController:ViewController = segue.destination as! ViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            viewController.places = self.places
            viewController.selectedPlace = self.names[indexPath.row]
        }
    }


}

