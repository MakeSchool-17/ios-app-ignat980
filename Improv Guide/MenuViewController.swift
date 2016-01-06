//
//  MenuViewController.swift
//  Improv Guide
//
//  Created by Ignat Remizov on 12/11/15.
//  Copyright © 2015 Ignat Remizov. All rights reserved.
//

import UIKit
import Darwin

class MenuViewController: UIViewController {
    ///The table view for the list of improv games
    @IBOutlet var tableView: UITableView!
    ///The data for the games from a plist on disk
    var improvData: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Used by NSPropertyListSerialization
        let format = UnsafeMutablePointer<NSPropertyListFormat>()
        //The root directory of the app
//        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        //Get the path to the plist file that contains improv game data
//        var plistPath = rootPath + "/Data.plist"
//        if (!NSFileManager.defaultManager().fileExistsAtPath(plistPath)) {
//            print("plist not in \(plistPath)")
        let plistPath = NSBundle.mainBundle().pathForResource("Data", ofType: "plist")!
//        }
        //Convert from the data on disk into memory
        let plistXML = NSFileManager.defaultManager().contentsAtPath(plistPath)
        do {
            self.improvData = try NSPropertyListSerialization.propertyListWithData(plistXML!, options: NSPropertyListReadOptions.MutableContainersAndLeaves, format: format) as! NSDictionary
            print(improvData)
        } catch let error {
            print("Error reading plist: \(error), format: \(format)");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentGame" {
            let instructionsVC = segue.destinationViewController as? InstructionsViewController
            instructionsVC?.gameData = sender as? NSDictionary
        }
    }


}

extension MenuViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //Warm-ups, Exercises, and scene games
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Warm-up"
        case 1:
            return "Exercise"
        case 2:
            return "Scene"
        default:
            return "\(section)"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.improvData.valueForKeyPath("Games.WarmUp.@count") as! Int
        case 1:
            return self.improvData.valueForKeyPath("Games.Exercise.@count") as! Int
        case 2:
            return self.improvData.valueForKeyPath("Games.Scene.@count") as! Int
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("item")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "item")
        }
        cell?.textLabel?.font = cell?.textLabel?.font.fontWithSize(18)
        
        //cell's text label = data.Games.<Type>[<row>][Title]
        switch indexPath.section {
        case 0:
            cell?.textLabel?.text = (self.improvData.valueForKeyPathWithIndexes("Games.WarmUp[\(indexPath.row)].Title") as! String)
        case 1:
            cell?.textLabel?.text = (self.improvData.valueForKeyPathWithIndexes("Games.Exercise[\(indexPath.row)].Title") as! String)
        case 2:
            cell?.textLabel?.text = (self.improvData.valueForKeyPathWithIndexes("Games.Scene[\(indexPath.row)].Title") as! String)
        default:
            cell?.textLabel?.text = "Title not Found"
        }

        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}


extension MenuViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO:Present Game Instructions
        switch indexPath.section {
        case 0:
            self.performSegueWithIdentifier("presentGame", sender: self.improvData.valueForKeyPathWithIndexes("Games.WarmUp[\(indexPath.row)]"))
        case 1:
            self.performSegueWithIdentifier("presentGame", sender: self.improvData.valueForKeyPathWithIndexes("Games.Exercise[\(indexPath.row)]"))
        case 2:
            self.performSegueWithIdentifier("presentGame", sender: self.improvData.valueForKeyPathWithIndexes("Games.Scene[\(indexPath.row)]"))
        default:
            break
        }
    }
}

extension NSObject {
    /// Returns the value for the derived property identified by a given key path, with indexes.
    ///
    /// :params: keyPath A key path of the form relationship.property (with one or more relationships); for example “department.name” or “department.manager.lastName”.
    func valueForKeyPathWithIndexes(keyPath:String) -> AnyObject {
        if keyPath.containsString("[") {
            let parts = keyPath.componentsSeparatedByString(".")
            var currentObj = self
            for part in parts {
                if let range1 = part.rangeOfString("[") {
                    let arrayKey = part.substringToIndex(range1.startIndex)
                    if let index = Int(part.substringToIndex(part.endIndex.predecessor()).substringFromIndex(range1.startIndex.successor())){
                        currentObj = (currentObj.valueForKey(arrayKey) as! NSArray).objectAtIndex(index) as! NSObject
                    } else {
                        print("The value between the [] in the key path is not an integer")
                    }
                } else {
                    currentObj = currentObj.valueForKey(part) as! NSObject
                }
            }
            return currentObj
        } else {
            return self.valueForKeyPath(keyPath)!
        }
    }
}