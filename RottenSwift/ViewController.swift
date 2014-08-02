//
//  ViewController.swift
//  RedditSwift
//
//  Created by Zachary Barryte on 7/19/14.
//  Copyright (c) 2014 Zachary Barryte. All rights reserved.
//

import UIKit

// ViewController is the class
// UIViewController is the super class
// UITableviewDataSource, UITableViewDelegate, UITextFieldDelegate, and JsonReceiverDelegate are protocols to which this class conforms
// ViewController needs to conform to those protocols in order to be various delegates
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, JsonReceiverDelegate {
    
    // this is the string of the url where the json file we want lives
    let kUrlString:NSString = "http://www.reddit.com/user/%@/comments.json"
    
    // These IBOutlets were connected to code from storyboard
    @IBOutlet var table:UITableView!
    @IBOutlet var usernameTextField:UITextField!
    
    var tableData:NSArray = NSArray()
    
    // This method is called upon successful load
    override func viewDidLoad() {
        // super refers to the UIViewController's method's
        super.viewDidLoad()
        
        // We set up table to delegate to the ViewController
        // We need the ViewController to be table's delegate and dataSource in order to populate the table
        table.delegate = self
        table.dataSource = self
        
        // We set up usernameTextField to delegate to the ViewController
        // This allows the keyboard to close when "done" is pressed
        usernameTextField.delegate = self
        
        // We set up the WebFetcher to delegate to the ViewController
        WebFetcher.sharedInstance.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This IBAction is connected to a button in storyboard
    // We use this method to tell our web fetcher to retreive online data
    @IBAction func fetchData() {
        
        // NSStrings may be concatenated using the + operator
        // Here, however, we formatted the string to include the username (replacing the %@ with the string specified in the text field)
        var completeUrlString: NSString = NSString(format:kUrlString,usernameTextField.text)
        
        WebFetcher.sharedInstance.loadJsonFromUrlWithString(completeUrlString)
        
        var alertView = UIAlertView()
        alertView.addButtonWithTitle("OK")
        alertView.title = "Fetching Data..."
        alertView.message = "Refresh table view to see comments."
        alertView.show()
    }
    
    // This method is required by the UITableViewDelegate protocol
    func tableView (tableView : UITableView , cellForRowAtIndexPath indexPath : NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("uid") as? UITableViewCell
        if (!cell) {
            cell = UITableViewCell()
            cell!.textLabel.font = UIFont.systemFontOfSize(10)
        }
        
        if (tableData.count > 0) {
            cell!.textLabel.text = tableData.objectAtIndex(indexPath.row) as NSString
        }
        
        return cell!
    }
    
    // This method is required by the UITableViewDataSource protocol
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableData.count
    }
    
    // This method is required by JsonReceiverDelegate
    func receiveJson(jsonDictionary:NSDictionary) {
        
        // This is just parsing of the Json
        // Your parsing will likely, be different, since your file will be structured differently likely
        var dataDictionary: NSDictionary = jsonDictionary.objectForKey("data") as NSDictionary
        var childrenArray : NSArray = dataDictionary.objectForKey("children") as NSArray
        var bodyArray: NSMutableArray = NSMutableArray()
        for child : AnyObject in childrenArray {
            var dictionary : NSDictionary = child as NSDictionary
            var dictionaryInner : NSDictionary = dictionary.objectForKey("data") as NSDictionary
            var bodyString : NSString = dictionaryInner.objectForKey("body") as NSString
            bodyArray.addObject(bodyString)
        }
        
        tableData = bodyArray;
        
        table.reloadData()
    }
    
    // This method is required by UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}