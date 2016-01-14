//
//  InstructionsViewController.swift
//  Improv Guide
//
//  Created by Ignat Remizov on 12/12/15.
//  Copyright © 2015 Ignat Remizov. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    @IBOutlet var titleView:UINavigationBar!
    @IBOutlet var descriptionView:UITextView!
    
    var gameData:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.topItem?.title = (gameData?.valueForKey("Title") as? String)
        descriptionView.text = (gameData?.valueForKey("Description") as? String) ?? ""
        titleView.shadowImage = UIImage()
        titleView.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(sender:AnyObject) {
        dismissViewControllerAnimated(true, completion:nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startGame" {
            if let game = segue.destinationViewController as? PagedGameViewController {
                game.gameData = gameData
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
