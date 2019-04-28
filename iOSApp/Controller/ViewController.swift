//
//  ViewController.swift
//  iOSApp
//
//  Created by Colton Wiethorn on 4/26/19.
//  Copyright © 2019 Colton Wiethorn. All rights reserved.
//  BASE CODE, FOR NAVIGATING FUNCTIONALITY, IS OFF OF CLASS EXAMPLE "STUDENT NAVIGATOR"
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    var places:[String:Place] = [String:Place]()
    var selectedPlace:String = "unknown" 
    var locations:[String] = [String]()
    var selectedLocation:String = ""
    var category:[String] = [String]()
    var selectedCategoryStr:String = ""
    var selectedCategoryIndex:Int = -1
    
    @IBOutlet weak var placeTableView: UITableView!
    @IBOutlet weak var placeIdLab: UILabel!
    @IBOutlet weak var locationsTF: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var addButt: UIButton!
    @IBOutlet weak var removeButt: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //NSLog("in ViewController.viewDidLoad with: \(selectedStudent)")
        placeTableView.delegate = self
        placeTableView.dataSource = self


        // round the buttons
        addButt.layer.cornerRadius = 15
        removeButt.layer.cornerRadius = 15

        //optional unwrapping with ? first below displays an optional value, which must be unwrapped.
        // ? is optional unwrapping whereas ! is forced unwrapping. Only use ! when you know
        // unwrapping will not result in nil value. Otherwise use if-let
        //studIdLab.text = "\(students[selectedStudent]?.placeid)"
        // Below works OK, but without using a guard (if) to protect against nil
        //studIdLab.text = NSString(format:"%i",(students[selectedStudent]?.placeid)!) as String
        // see also the if-let construction, as example in AlertView OK of StudentTableViewController

        placeIdLab.text = "\(places[selectedPlace]!.placeid)"
        self.title = places[selectedPlace]?.name

        locations = ["Hot Weather - Hot & Sunny",
                   "Cold Weather - Cold & Wet",
                   "Beach Location has a beautiful beach",
                   "Hiking Mountain Trails",
                   "Surfing Beach has killer waves",
                   "Blah The most boring destination ever"]
        locations = locations.sorted()
        category = places[selectedPlace]!.category.sorted()

        // setup a picker for selecting a course to be added for this student.
        categoryPicker.delegate = self
        //categoryPicker.dataSource = self as? UIPickerViewDataSource
        categoryPicker.removeFromSuperview()
        //categoryPicker.reloadInputViews()
        locationsTF.inputView = categoryPicker
        // of course count is greater than 0. All courses must have space after pre/num
        selectedLocation =  (locations.count > 0) ? locations[0] : "unknown unknown"
        let crs:[String] = selectedLocation.components(separatedBy: " ")
        locationsTF.text = crs[0]

        // so we can return a modified student
        self.navigationController?.delegate = self
        
        
        
        
        
        // place an add button on the right side of the nav bar for adding a student
        // call addStudent function when clicked.
        let addDetailButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(ViewController.addDetail))
        self.navigationItem.rightBarButtonItem = addDetailButton
        
        //let home:Place = Place(jsonStr: "{\"name\":\"Home\",\"placeid\":60124,\"category\":[\"Food REPLACED ERROR\",\"Sleep REPLACED ERROR\"]}")
        //self.places["Home"] = home
        
        if let path = Bundle.main.path(forResource: "places", ofType: "json"){
            do {
                let jsonStr:String = try String(contentsOfFile:path)
                let data:Data = jsonStr.data(using: String.Encoding.utf8)!
                let dict:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                for addDetail:String in dict.keys {
                    let aDetail:Place = Place(dict: dict[addDetail] as! [String:Any])
                    self.places[addDetail] = aDetail
                }
            } catch {
                print("contents of places.json could not be loaded")
            }
        }
        // sort so the names are listed in the table alphabetically (first name)
        self.title = "Details List"
        
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    // called with the Navigation Bar Add button (+) is clicked
    @objc func addDetail() {
        print("add Destination button clicked")
        
        //  query the user for the new student name and number. empty category
        let promptND = UIAlertController(title: "New Detail", message: "Enter New Destination Detail", preferredStyle: UIAlertController.Style.alert)
        // if the user cancels, we don't want to add a student so nil handler
        promptND.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        // setup the OK action and provide a closure to be executed when/if OK selected
        promptND.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //print("you entered name: \(String(describing: promptND.textFields?[0].text)). Number: \(String(describing: promptND.textFields?[1].text)).")
            // Want to provide default values for name and placeid
            let _:String = (promptND.textFields?[0].text == "") ?
                "unknown" : (promptND.textFields?[0].text)!
            // since didn't specify the keyboard, don't know whether id is empty, alpha, or numeric:
            //var newStudID:Int = -1
            //if let myNumber = NumberFormatter().number(from: (promptND.textFields?[1].text)!) {
            //    newStudID = myNumber.intValue
            //}
            //print("creating and adding student \(newStudName) with id: \(newStudID)")
            //let aDetail:Place = locations(category: addDetail)
            //self.locations[addDetail] = aDetail
            self.locations = Array(self.locations).sorted()
            //self.tableView.reloadData()
        }))
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Detail Description"
        })
        
        present(promptND, animated: true, completion: nil)
    }
    
    
    
    

    @IBAction func addButtonClicked(_ sender: Any) {
        // add the selected course to the students takes
        //print("Adding course \(selectedCourse) to takes for \(selectedStudent)")
        if !(places[selectedPlace]?.category.contains(selectedLocation))!{
            places[selectedPlace]?.category.append(selectedLocation)
            category = (places[selectedPlace]?.category)!
            category = category.sorted()
            placeTableView.reloadData()
        }
    }

    @IBAction func removeButtClicked(_ sender: Any) {
        // remove the selected course from the student takes
        //print("Removing course \(selectedCourse) to takes for \(selectedStudent)")
        if (places[selectedPlace]?.category.contains(selectedLocation))!{
            let index:Int = (places[selectedPlace]?.category.firstIndex(of: selectedLocation))!
            places[selectedPlace]?.category.remove(at: index)
            category = (places[selectedPlace]?.category)!
            category = category.sorted()
            placeTableView.reloadData()
        }
    }

    // touch events on this view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.locationsTF.resignFirstResponder()
    }

    // MARK: -- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.locationsTF.resignFirstResponder()
        return true
    }

    // MARK: -- UIPickerVeiwDelegate method
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocation = locations[row]
        let tokens:[String] = selectedLocation.components(separatedBy: " ")
        self.locationsTF.text = tokens[0]
        self.locationsTF.resignFirstResponder()
    }

    // MARK: -- UIPickerviewDataSource method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // UIPickerviewDataSource method
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    // UIPickerViewDelegate method
    func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let crs:String = locations[row]
        let tokens:[String] = crs.components(separatedBy: " ")
        return tokens[0]
    }

    // MARK: -- UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // UITableViewDataSource method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }

    //@IBOutlet weak var courseTitle: UILabel!
    // UITableViewDataSource method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("in tableView cellForRowAt, row: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceTableViewCell
        let crsSegs:[String] = category[indexPath.row].components(separatedBy: " ")
        cell.placeNum = crsSegs[0]
        var titleStr:String = ""
        for i:Int in 1 ..< crsSegs.count {
            titleStr.append("\(crsSegs[i]) ")
        }
        cell.placeTitle = titleStr
        return cell
    }

    //tableview delegate (UITableViewDelegate method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("tableView didSelectRowAT \(indexPath.row)")
        selectedCategoryStr = ((places[selectedPlace])?.category[indexPath.row])!
        selectedCategoryIndex = indexPath.row
    }

    // If self is a navigation controller delegate (see above in view did load)
    // then this method will be called after the Nav Conroller back button click, but
    // before returning to the previous view. This provides an opportunity to update
    // that view's data with any changes from this view. This approach is
    // accepted practice for sending data back after a segue with nav controller.
    // Here this is only important to be sure the same courses persist coming back here.
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        //print("entered navigationController willShow viewController")
        if let controller = viewController as? PlaceTableViewController {
            // pass back the students dictionary with potentially modified takes.
            controller.places = self.places
            // don't need to reload data. Students don't change here, but it can be done
            controller.tableView.reloadData()
        }
    }

}

