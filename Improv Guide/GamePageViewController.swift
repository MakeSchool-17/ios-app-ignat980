//
//  GamePageViewController.swift
//  Improv Guide
//
//  Created by Ignat Remizov on 12/14/15.
//  Copyright © 2015 Ignat Remizov. All rights reserved.
//

import UIKit

class GamePageViewController: UIViewController {
    
    @IBOutlet var instructions: UITextView!
    @IBOutlet var instructionHeight: NSLayoutConstraint!
    
    var step:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineBreakMode = .ByWordWrapping
//        instrutionHeight.constant = NSString(string: instructions.text).boundingRectWithSize(CGSizeMake(instructions.frame.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : instructions.font!, NSParagraphStyleAttributeName: paragraphStyle], context: nil).height
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
//        instructions.sizeToFit()
//        instructionHeight.constant = instructions.frame.height
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        instructions.sizeToFit()
        instructionHeight.constant = instructions.frame.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        instructions.sizeToFit()
    }
    
    
    @IBAction func goBack(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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