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
    
    let paragraphStyle = NSMutableParagraphStyle()
    
    var gameData: String? {
        didSet {
            if gameData != nil{
                let attributes:[String:AnyObject] = [NSParagraphStyleAttributeName:paragraphStyle]
                instructions.attributedText = NSMutableAttributedString(string: gameData!, attributes: attributes)
                instructions.font = UIFont.systemFontOfSize(36)
            }
        }
    }
    var random:Array<String> = [] {
        didSet {
            if !random.isEmpty {
                let attributedInstructions = NSMutableAttributedString(attributedString: instructions.attributedText)
                let appenededRandom = NSMutableAttributedString(string: "\nor generate here", attributes:[NSLinkAttributeName:"", NSParagraphStyleAttributeName:paragraphStyle])
                attributedInstructions.appendAttributedString(appenededRandom)
                instructions.attributedText = attributedInstructions
                instructions.font = UIFont.systemFontOfSize(36)
            }
        }
    }
    var randomData: NSDictionary!
    var step:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStyle.setParagraphStyle(NSParagraphStyle.defaultParagraphStyle())
        paragraphStyle.alignment = .Center
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
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//        instructionHeight.constant = instructions.size
//    }


}

extension GamePageViewController:UITextViewDelegate {
    
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        if random.count != 0 {
            let randomString = "\n\(randomData.valueForKeyPath("\(random[0]).@randomElement") as! String)"
            let range = NSString(string:textView.attributedText.string).rangeOfString(gameData!)
            let instructionText = NSMutableAttributedString(attributedString: textView.attributedText.attributedSubstringFromRange(range))
            let linkAttributes = textView.attributedText.attributesAtIndex(range.location + range.length + 2, effectiveRange: nil)
            let attributedRandomString = NSMutableAttributedString(string: randomString, attributes: linkAttributes)
            instructionText.appendAttributedString(attributedRandomString)
            textView.attributedText = instructionText
        }
        return false
    }
}